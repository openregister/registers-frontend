module Admin
  class RegistersController < AdminController
    before_action :set_register, only: %i[edit update destroy]
    before_action :set_government_organisations, except: :index

    def index
      @registers = Register.by_popularity
    end

    def new
      @register = Register.new
    end

    def edit; end

    def create
      @register = Register.new(register_params)
      if @register.save
        PopulateRegisterDataInDbJob.perform_later(@register)
        redirect_to admin_registers_url
      else
        flash[:alert] = "Please check errors"
        render :new
      end
    end

    def update
      if @register.update_attributes(register_params)
        PopulateRegisterDataInDbJob.perform_later(@register)
        redirect_to admin_registers_url
      else
        flash[:alert] = "Please check errors"
        render :edit
      end
    end

    def destroy
      @register.destroy
      redirect_to admin_registers_path
    end

    def sort
      params[:register].each_with_index do |id, index|
        Register.where(id: id).update_all(position: index + 1)
      end
      head :ok
    end

  private

    def set_register
      @register = Register.find(params[:id])
    end

    def set_government_organisations
      @government_organisations = Register.find_by(slug: 'government-organisation')
                                          .records
                                          .where(entry_type: 'user')
                                          .current
    end

    def register_params
      params.require(:register).permit(:name,
                                        :slug,
                                        :register_phase,
                                        :authority,
                                        :description,
                                        :contextual_data,
                                        :related_registers,
                                        :url,
                                        :position,
                                        :seo_title,
                                        :meta_description,
                                        :featured)
    end
  end
end
