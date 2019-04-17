class ArticlesController < ApplicationController
  
  def index
    @articles = Article.all
  end
  def new
    @article =Article.new
  end
  
  
  
  def create
    #render plain: params[:article].inspect
    @article = Article.new(article_params)
    if  @article.save
     redirect_to article_path(@article)
     flash[:notice] = "article added "
    else
     render 'new'
    end
  end
  
  def destroy
    @article = Article.find(params[:id])
    @article.destroy
    flash[:notice] = "article with id #{params[:id]} has been deleted"
    redirect_to articles_path
  end
  
  def edit
    @article = Article.find(params[:id])
  end
  
  
  def update
    @article = Article.find(params[:id])
    if (@article.update(article_params))
      flash[:notice] = "article is updated"
      redirect_to article_path(@article)
    else
      render 'new'
    end
  end
  
  def show
    @article = Article.find(params[:id])
  end
 private 
  def article_params
    params.require(:article).permit(:title,:description)
  end
end