module Spina
  module Admin
    class RegistersController < AdminController
      before_action :set_breadcrumb
      before_action :set_register, only: %i[edit update destroy]
      before_action :set_government_organisations, only: %i[new edit]

      layout "spina/admin/admin"

      def index
        @registers = Register.by_name
      end

      def new
        add_breadcrumb("New #{t('spina.registers.scaffold_name')}", spina.new_admin_register_path)
        @register = Register.new
      end

      def edit
        add_breadcrumb(@register.name)
      end

      def create
        add_breadcrumb("New #{t('spina.registers.scaffold_name')}")
        @register = Register.new(register_params)
        if @register.save
          PopulateRegisterDataInDbJob.perform_later(@register)
          flash.now[:success] = "Successfull saved"
          redirect_to spina.edit_admin_register_url(@register)
        else
          flash.now[:alert] = "Please check errors"
          render :new
        end
      end

      def update
        add_breadcrumb(@register.name)
        if @register.update_attributes(register_params)
          PopulateRegisterDataInDbJob.perform_later(@register)
          flash.now[:success] = "Successfull saved"
          redirect_to spina.edit_admin_register_url(@register)
        else
          flash.now[:alert] = "Please check errors"
          render :edit
        end
      end

      def destroy
        @register.destroy
        redirect_to spina.admin_registers_path
      end

    private

      def set_register
        @register = Register.find(params[:id])
      end

      def set_breadcrumb
        add_breadcrumb(t('spina.registers.scaffold_name_plural'), spina.admin_registers_path)
      end

      def set_government_organisations
        @government_organisations = Register.find_by(slug: 'government-organisation')
                                            .records
                                            .where(entry_type: 'user')
      end

      def register_params
        params.require(:register).permit(:name, :slug, :register_phase, :authority, :description, :contextual_data, :related_registers, :url)
      end
    end
  end
end
