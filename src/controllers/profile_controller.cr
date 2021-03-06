
class ProfileController < ApplicationController
  getter user = User.new

  before_action do
    only [:show, :edit, :update, :destroy] { set_user }
  end

  def index
    users = User.all
    render "index.slang"
  end

  def show
    render "show.slang"
  end

  def new
    render "new.slang"
  end

  def edit
    render "edit.slang"
  end

  def create
    user = User.new user_params.validate!
    pass = user_params.validate!["password"]
    user.password = pass if pass
    user.role = 0
    user.approved = 0
    if user.save
      session[:user_id] = user.id
      redirect_to "/", flash: {"success" => "Created User successfully."}
    else
      flash[:danger] = "Could not create User!"
      render "new.slang"
    end
  end

  def update
    user.set_attributes user_params.validate!
    if user.save
      redirect_to action: :show, flash: {"success" => "User has been updated."}
    else
      flash[:danger] = "Could not update User!"
      render "edit.slang"
    end
  end

  def destroy
    user.destroy
    redirect_to "/", flash: {"success" => "User has been deleted."}
  end

  private def user_params
    params.validation do
      required :email
      required :name
      required :company
      optional :password
      optional :approved
      optional :role
      optional :phone
    end
  end

  private def set_user
    @user = current_user.not_nil!
  end

end
