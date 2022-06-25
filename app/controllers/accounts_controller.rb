class AccountsController < ApplicationController
  before_action :set_account, only: [:show, :edit, :update, :destroy]

  def index
    if params[:query].present?
      @accounts = current_user.accounts.where("name ILIKE ?", "%#{params[:query]}%")
    else
      @accounts = current_user.accounts
    end
  end

  def new
    @account = Account.new(int_type: "Civil", switch_date: "à partir du")
  end

  def show
    selectionner()
    trier()
    periodes()
    nbjours()
    soldes()
  end

  def create
    @account = Account.new(account_params)
    @account.user = current_user
    if @account.save
      redirect_to account_path(@account), notice: 'Account was successfully created.'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @account.update(account_params)
      redirect_to edit_account_path(@account), notice: 'Account was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @account.destroy
    redirect_to accounts_path, notice: 'Account was successfully destroyed.'
  end

  private

  def set_account
    @account = Account.find(params[:id])
  end

  def account_params
    # params.require(:account).permit(:name, credits_attributes: [:id, :_destroy, :account_id, :name, :completed, :due])
    params.require(:account).permit(
      :name, :date,:int_type, :percentage, :total, :switch_date,
      credits_attributes: Credit.attribute_names.map(&:to_sym).push(:_destroy),
      payments_attributes: Payment.attribute_names.map(&:to_sym).push(:_destroy),
      costs_attributes: Cost.attribute_names.map(&:to_sym).push(:_destroy),
      capitalisations_attributes: Capitalisation.attribute_names.map(&:to_sym).push(:_destroy)
    )
  end

  def selectionner
    @rates = []
    @credits = Credit.where(account_id: @account.id)
    @payments = Payment.where(account_id: @account.id)
    @costs = Cost.where(account_id: @account.id)
    @capitalisations = Capitalisation.where(account_id: @account.id)
    if @account.int_type == "Conventionnel"
      Rate.where(int_type: "conventionnel").each do |r|
        unless @account.periods.empty?
          r.destroy if r.id != @account.periods.first.rate_id && r == Rate.where(id: Period.where(account_id: @account))
        end
      end
      @rates << Rate.create(date: Date.new(1980, 1, 1), date_fin: Date.new(2050, 12, 31), pct: @account.percentage / 100, int_type: "conventionnel")
    elsif @account.int_type == "Commercial" && @account.switch_date == "avant"
      a = Rate.where('int_type = ? AND date_fin > ? AND switch_date != ?',
        @account.int_type.downcase,
        @account.date.to_s, "après")
        bornesuperieure = a.first.id
      b = Rate.where('int_type = ? AND date <= ? AND switch_date != ?',
        @account.int_type.downcase,
        @credits.first.date.to_s, "après")
        borneinferieure = b.last.id

      @rates = Rate.where('id BETWEEN ? AND ? AND switch_date != ?', borneinferieure, bornesuperieure, "après")

    else
      bornesuperieure = Rate.where('int_type = ? AND date_fin > ?', @account.int_type.downcase, @account.date.to_s).first.id
      borneinferieure = Rate.where('int_type = ? AND date <= ?', @account.int_type.downcase, @credits.first.date.to_s).last.id
      @rates = Rate.where('id BETWEEN ? AND ? AND switch_date != ?', borneinferieure, bornesuperieure, "avant")
    end
  end

  def trier
    @periodes = []
    @glob = @payments + @rates.drop(1) + @capitalisations + [@account, @credits.first]
    dt = @glob.map {|e| e.date}
    @dt = dt.uniq.sort
  end

  def periodes
    Period.where(account_id: @account.id).destroy_all
    for n in (1 ... @dt.count)
      if @account.int_type == "Conventionnel" || @account.switch_date != "avant"
        tx = Rate.where('int_type = ? AND date <= ?', @account.int_type.downcase, (@dt[n - 1] + 1).to_s)
      else
        tx = Rate.where('int_type = ? AND date <= ? AND switch_date != ?', @account.int_type.downcase, (@dt[n - 1] + 1).to_s, "après")
      end
      Period.create(date: @dt[n - 1],
                    date_fin: @dt[n], # attention de - 1 à p.date -> corriger les p.date_fin + 1????
                    account_id: @account.id,
                    rate_id: tx.last.id)
    end
    @periods = @account.periods
  end

  def nbjours
    @nbjours = []
    @clas = []
    @dd = []
    @df = []
    @periods.each_with_index do |p, ip|
      if ip.zero?
        dd = p.date
      else
        classe(ip - 1)
        if @classes.include?("Payment")
          dd = p.date + 1
        else
          dd = p.date
        end
      end
      classe(ip)
      @clas << @classes
      if @classes.include?("Payment") || @classes.include?("Account")
        df = p.date_fin + 1
      else
        df = p.date_fin
      end
      nbj = (df - dd).to_i
      @nbjours << nbj
      @dd << dd
      @df << df
    end
  end

  def antecosts
    @antecosts = @costs.where('date < ?', @credits.first.date.to_s).map {|a| a.amount}
  end

  def soldes
    # au sein de la periode
    @kapital = [] # array des @k
    @interets = [] # array des @interet
    @couts = [] # array des @cout
    antecosts
    @pmt = []
    # soldes
    @soldek = []
    @soldeint = []
    @soldecosts = []
    @periods.each_with_index do |p, ip|
      if ip.positive?
        # 1. incorporation du capital reporte de la periode n-1
        @k = [@soldek[ip - 1]]
        # 2. incorporation des couts reportes de la periode n-1
        @cout = [@soldecosts[ip - 1]]
        # 3. incorporation des interets reportes de la periode n-1
        @interet = [@soldeint[ip - 1].round(2)]
        # 4. interet periode sur capital reporte
        diviseur(@dd[ip], @df[ip])
        @interet << (@k.last * p.rate.pct * (@df[ip] - @dd[ip]).to_i / @div).round(2) # leap year OK
      else
        @k = []
        @interet = []
        @cout = @antecosts
      end
      @credits.inperiod(p).each do |cr|
        # 1. creances cumulees sur la periode
        @k << (cr.amount).round(2)
        # 2. interets cumules sur creances de la periode
        diviseur(cr.date, @df[ip])
        @interet << (cr.amount * p.rate.pct * (@df[ip] - cr.date).to_i / @div).round(2) # quid leap year
      end
      @costs.inperiod(p).each do |cst|
        # couts cumulees sur la periode
        @cout << (cst.amount).round(2)
      end
      # cumul du capial pour chaque periode du decompte
      @kapital << @k
      # cumul des couts pour chaque periode du decompte
      @couts << @cout
      # cumul des interets paour chaque periode du decompte
      @interets << @interet

      if @payments.find_by(date: p.date_fin)
        # tableau des paiements a imputer
        @pmt << @payments.find_by(date: p.date_fin).amount
      else
        @pmt << 0
      end
      capitaliser(@pmt[ip], @interets[ip].sum, @kapital[ip].sum, @couts[ip].sum, ip)
    end
  end

  def diviseur(dd, df)
    endyear = Date.new(dd.year + 1, 1, 1)
    if Date.gregorian_leap?(dd.year) && Date.gregorian_leap?((df - 1).year)
      @div = 366
    elsif Date.gregorian_leap?(dd.year)
      @div = ((endyear - dd) / (df - dd) * 366) + ((df - endyear) / (df - dd) * 365)
    elsif Date.gregorian_leap?((df - 1).year)
      @div = ((endyear - dd) / (df - dd) * 365) + ((df - endyear) / (df - dd) * 366)
    else
      @div = 365
    end
  end

  def classe(periodnr)
    @classes = []
    @glob.each do |g|
      @classes << g.class.to_s if g.date == @periods[periodnr].date_fin
    end
  end

  def capitaliser(pmt, int, k, cout, ip)
    classe(ip)
    if @classes.include?("Capitalisation")
      soldeintcap = 0
      soldekcap = (k + int).round(2)
      imputer(pmt, soldeintcap, soldekcap, cout)
    else
      imputer(pmt, int, k, cout)
    end
  end

  def imputer(pmt, int, k, cout)
    if pmt >= int + cout
      @soldecosts << 0
      @soldeint << 0
      @soldek << (k - (pmt - cout - int)).round(2)
    elsif pmt >= cout
      @soldecosts << 0
      @soldeint << int - (pmt - cout).round(2)
      @soldek << k
    elsif pmt < cout
      @soldecosts << (cout - pmt).round(2)
      @soldeint << int
      @soldek << k
    end
  end
end
