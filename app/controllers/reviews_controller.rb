class ReviewsController < ApplicationController
  def new
    @item = Item.find(params[:item_id])
  end

  def create
    @item = Item.find(params[:item_id])
    review = @item.reviews.create(review_params)
    if review.save
      redirect_to "/items/#{@item.id}"
    else
      flash.now[:error] = review.errors.full_messages.to_sentence
      render :new
    end
  end

  def edit
    @review = Review.find(params[:review_id])
  end

  def update
    @item = Item.find(params[:item_id])
    @review = Review.find(params[:review_id])
    @review.update(review_params)

    if @review.save
      redirect_to "/items/#{@item.id}"
    else
      flash.now[:error] = @review.errors.full_messages.to_sentence
      render :edit
    end
  end

  def destroy
    item = Item.find(params[:item_id])
    review = Review.find(params[:review_id])
    review.destroy
    redirect_to "/items/#{item.id}"
  end

  private

  def review_params
    params.permit(:title, :content, :rating)
  end
end
