class TestsController < Simpler::Controller
  def index
    render plain: "Plain text response \n"
    status 201
    @time = Time.now
  end

  def create; end

  def show
    @test_id = params[:id]
  end
end
