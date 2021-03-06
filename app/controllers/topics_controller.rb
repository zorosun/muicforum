class TopicsController < ApplicationController
  before_action :set_topic, only: [:show, :edit, :update, :destroy]

  def search
  	if(params[:search] && params[:search] != '')
  		@topics = Topic.search(params[:search]).order("updated_at DESC").paginate(per_page: 15, page: params[:page])
  	end
  end

  def like
  	@topic = Topic.find(params[:id])
  	@topic.liked_by current_user
  	@users = @topic.votes.up.by_type(User).voters
  		
  	respond_to do |format|
      format.html { redirect_to board_topic_path(@topic.board, @topic) }
      format.js
    end 
  end

  def unlike
  	@topic = Topic.find(params[:id])
  	@topic.unliked_by current_user
  	@users = @topic.votes.up.by_type(User).voters

  	respond_to do |format|
      format.html { redirect_to board_topic_path(@topic.board, @topic) }
      format.js
    end

  end

  # GET /topics
  # GET /topics.json
  def index
    if(params[:tag])
    	@topics = Topic.tagged_with(params[:tag]).paginate(per_page: 15, page: params[:page])
  	else
    	@topics = Topic.paginate(per_page: 15, page: params[:page])
 	end
end

  # GET /topics/1
  # GET /topics/1.json
  def show
  	load_board
  	@topic = Topic.find(params[:id])
  	@topic.board = @board
  	@comments = @topic.comments
  	@users = @topic.votes.up.by_type(User).voters
  	@topic.keyword_list = @topic.keyword_list[0..4]
  end


  # GET /topics/new
  def new
  	load_board
    @topic = Topic.new
  end

  # GET /topics/1/edit
  def edit
  	@topic.keyword_list = @topic.keyword_list[0..4]
  end

  # POST /topics
  # POST /topics.json
  def create
  	load_board
    @topic = Topic.new(topic_params)
    @topic.user_id = current_user.id
    @topic.board = @board
    @topic.keyword_list = @topic.keyword_list[0..4]


    if current_user && @topic.save
  		flash[:success] = "Topic was successfuly created."
  		respond_to do |format|
  			format.html { redirect_to :controller => 'topics', :action => 'show', :id => @topic.id }
  	    	format.js
    	end 
  	else
  		render action: "new"
  	end
  end

  # PATCH/PUT /topics/1
  # PATCH/PUT /topics/1.json
  def update
      if @topic.update(topic_params)
      	flash[:success] = "Topic was successfuly updated."
      	redirect_to board_topic_path(@topic.board.id, @topic.id)
      else

      end
  end

  # DELETE /topics/1
  # DELETE /topics/1.json
  def destroy
  	@board = @topic.board
    @topic.destroy
    flash[:success] = "Topic was successfuly deleted."
    redirect_to :controller => 'boards', :action => 'show', :id => @board.id 
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_topic
      @topic = Topic.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def topic_params
      params.require(:topic).permit(:title, :subtitle, :user_id, :board_id, :keyword_list)
    end

    def load_board
    	if Board.exists?(params[:board_id])
    		@board = Board.find(params[:board_id])
    	end

    	unless @board
    		redirect_to(boards_path, :notice => "Please specify a valid board" )
    	end
    end
end
