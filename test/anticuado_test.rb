require 'test_helper'

class AnticuadoTest < Minitest::Test
  def test_current_dir
    assert_equal Dir.pwd, Anticuado.current_dir
  end

  def test_project_dir
    project = "test"
    assert_equal "#{Dir.pwd}/test", Anticuado.project_dir(project)
  end
end
