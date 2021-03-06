class Episode < ActiveRecord::Base
  has_many :reviews, dependent: :destroy
  has_many :votes, as: :voteable
  has_many :favorites
  has_many :users, through: :favorites

  validates :title, presence: true
  validates :season, presence: true
  validates :episode_number, presence: true, uniqueness: { scope: :season }

  def vote_score
    votes.sum(:value)
  end

  def has_upvote_from?(user)
    vote = vote_from(user)
    vote.present? && vote.upvote?
  end

  def has_downvote_from?(user)
    vote = vote_from(user)
    vote.present? && vote.downvote?
  end

  def vote_from(user)
    votes.find_by(user: user)
  end

  def self.search(search)
    where('title ILIKE ?', "%#{search}%")
  end

  def self.populate_index_with(query)
    if query[:season]
      @episodes = Episode.includes(:votes, :reviews, { votes: :user }).where(season: query[:season]).order(:episode_number).page(query[:page])
    elsif query[:search]
      @episodes = Episode.includes(:votes, :reviews, { votes: :user }).search(query[:search]).order(:season, :episode_number).page(query[:page])
    elsif query[:newest]
      @episodes = Episode.includes(:votes, :reviews, { votes: :user }).order(season: :desc).page(query[:page]).per(24)
    else
      @episodes = Episode.includes(:votes, :reviews, { votes: :user }).order(:season, :episode_number).page(query[:page]).per(24)
    end
  end
end
