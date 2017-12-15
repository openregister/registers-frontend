module Spina
  module Admin
    class RegistersController < AdminController

      before_action :set_breadcrumb, :set_register, only: [:edit, :update, :destroy]
      before_action :initialize_client
      before_action :set_government_organisations, only: [:new, :edit]

      layout "spina/admin/admin"

      def index
        @registers = Spina::Register.by_name
      end

      def new
        add_breadcrumb "New #{t('spina.registers.scaffold_name')}", spina.new_admin_register_path
        @register = Spina::Register.new
      end

      def create
        add_breadcrumb "New #{t('spina.registers.scaffold_name')}"
        @register = Spina::Register.new(register_params)
        if @register.save
          flash.now[:success] = "Successfull saved"
          redirect_to spina.edit_admin_register_url(@register)
        else
          flash.now[:alert] = "Please check errors"
          render :new
        end
      end

      def update
        add_breadcrumb @register.name
        if @register.update_attributes(register_params)
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
        @register = Spina::Register.find(params[:id])
      end

      def set_breadcrumb
        add_breadcrumb t('spina.registers.scaffold_name_plural'), spina.admin_registers_path
      end

      def initialize_client
        @@registers_client ||= RegistersClient::RegisterClientManager.new(cache_duration: 600)
      end

      def set_government_organisations
        register_data = @@registers_client.get_register('government-organisation', 'beta')
        @government_organisations = register_data.get_records
      end

      def register_params
        params.require(:register).permit(:name, :slug, :url, :history, :register_phase, :custodian, :authority, :description,
                                          phases_attributes: [:name, :phase_update, :position, :_destroy, :id],
                                          steps_attributes: [:step_phase, :title, :completed, :content, :position, :_destroy, :id])
      end
    end
  end
end
