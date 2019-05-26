module Auth
  class RegistrationsController < DeviseTokenAuth::RegistrationsController
    private

    def sign_up_params
      params.require(:registration).permit(:name, :email, :image, :password, :password_confirmation)
    end
   
    def account_update_params
      params.require(:registration).permit(:name, :email, :image)
    end
  end
end
