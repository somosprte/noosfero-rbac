class RoleController < AdminController
  protect 'manage_environment_roles', :environment

  def index
    @roles = environment.roles.where profile_id: nil
  end

  def new
    @role = Role.new
  end

  def create
    params[:role] ||= {}
    @role = Role.new :name => params[:role][:name], :permissions => params[:role][:permissions], :environment => environment
    if @role.save
      redirect_to :action => 'show', :id => @role
    else
      session[:notice] = _('Failed to create role')
      render :action => 'new'
    end
  end

  def show
    @role = environment.roles.find(params[:id])
  end

  def edit
    @role = environment.roles.find(params[:id])
  end 

  def remove
    @role = environment.roles.find(params[:id])
    @members = profile.members_by_role(@role)
    member_roles = params[:roles] ? environment.roles.find(params[:roles].select{|r|!r.to_i.zero?}) : []
    append_roles(@members, member_roles, profile)
    if @role.destroy
      session[:notice] = _('Role successfully removed!')
    else
      session[:notice] = _('Failed to remove role!')
    end
    redirect_to :action => 'index'
  end

  def update
    @role = environment.roles.find(params[:id])
    if @role.update(params[:role])
      redirect_to :action => 'show', :id => @role
    else
      session[:notice] = _('Failed to edit role')
      render :action => 'edit'
    end
  end

end
