class AttachmentsController < ApplicationController
  def index
    @attachments = Attachment.where(attachable_type: params[:attachable_type],
                                    attachable_id: params[:attachable_id],
                                    attachable_additional_type: params[:attachable_additional_type],
                                   ).order(:id)
    render :json => @attachments.collect { |p| p.to_jq_upload }.to_json
  end

  def create
    # 如果是一般表單的附件上傳，不會傳送 attachable_additional_type 參數
    @source = params[:attachable_type]&.constantize&.find_by_id(params[:attachable_id])
    @attachment = @source&.attachments&.new || Attachment.new

    @attachment.attachment = params[:attachment] || params[:file]
    @attachment.attachable_type = params[:attachable_type]
    @attachment.attachable_id = params[:attachable_id]
    @attachment.attachable_additional_type = params[:attachable_additional_type]

    if @attachment.save
      render :json => {status: 'OK', files:[@attachment.to_jq_upload], link: @attachment.attachment.url(:original)}.to_json
    else
      render :json => [{:error => "#{@attachment.errors.full_messages}"}], :status => 304
    end
  end

  def destroy
    @attachment = Attachment.find(params[:id])
    @attachment.destroy
    render body: nil, status: 200
  end
end

