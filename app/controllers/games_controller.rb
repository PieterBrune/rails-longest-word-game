require 'json'
require 'open-uri'

class GamesController < ApplicationController
  def new
    @letters = (0..9).map { ('a'..'z').to_a[rand(26)] }
  end

  def letter_overused?
    params[:letters].chars.all? do |letter|
      params[:letters].chars.count(letter) >= params[:word].chars.count(letter)
    end
  end

  def letter_included
    count = 0
    params[:word].chars.each do |letter|
      count += 1 unless params[:letters].chars.include?(letter)
    end
    count
  end

  def score
    url = "https://wagon-dictionary.herokuapp.com/#{params[:word]}"
    word_serialized = URI.open(url).read
    dictionary = JSON.parse(word_serialized)

    if params[:word].length > params[:letters].length || !letter_overused? || letter_included.positive?
      @result = "Sorry but #{params[:word]} can't be built out of #{params[:letters].upcase}"
    elsif !dictionary['found']
      @result = "Sorry but #{params[:word]} does not seem to be a valid English word"
    else
      @result = "Congrats, #{params[:word]} is a valid English word. Score: #{params[:word].length}"
      # / params[:time].to_f}
    end
  end
end
