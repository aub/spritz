class ResumeController < ContentController

  caches_with_references :show
  
  def show
    render :template => 'resume'
  end
end
