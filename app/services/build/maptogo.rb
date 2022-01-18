# frozen_string_literal: true
require 'open3'
class Build::Maptogo
  def initialize; end

  def build
    build_config = Rails.application.config_for('build/maptogo')
    puts build_config['commands'].inspect
    meta = initialize_meta(build_config)
    data = {}

    if(build_config['commands'].length() > 0 )

      ActionCable.server.broadcast(
        "build",
        {
          content: 'Build process started'
        }
      )
      build_config['commands'].each_with_index { |cmd, index|
        #puts cmd  
        
        Open3.popen3(*cmd) do |stdin, stdout, stderr, wait_thr|

         # puts "stdout is:" + stdout.read
        
       #   puts "stderr is:" + stderr.read

          ActionCable.server.broadcast(
            "build",
            {
              index: index,
              content: 'CMD: ' + cmd ,
              detail: stdout.read,
              error: stderr.read
            }
          )
  
        end

      }

    end
    

    result = { meta: meta, data: data }
  end

  private

  def initialize_meta(config)
    {
      version: config['version'] || '1.0.0',
      created_at: DateTime.current.to_s
    }
  end
end
