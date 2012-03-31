class Monologue::PostsSweeper < ActionController::Caching::Sweeper
  observe Monologue::Post


  def sweep(post)
    root_path = Monologue::Engine.routes.url_helpers.root_path if root_path.nil? # TODO: why do I have to do this to make tests pass? There must be something much more clean to make tests pass
    page_cache_directory = Rails.public_path if page_cache_directory.nil? # TODO: we should not need this either...
    unless post.just_the_revision_one_before.nil?
      current_post_path = "#{page_cache_directory}#{post.just_the_revision_one_before.url}.html" 
      File.delete current_post_path if File.exists? current_post_path
    end
    expire_page root_path
    FileUtils.rm_rf "#{page_cache_directory}/page"
  end

  alias_method :after_create, :sweep
  alias_method :after_update, :sweep 
  alias_method :after_destroy, :sweep

end