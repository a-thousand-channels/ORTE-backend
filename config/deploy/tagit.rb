# frozen_string_literal: true

namespace :deploy do
  task :tagit do
    remote = fetch(:remote, 'origin')
    stage  = fetch(:stage)
    branch = fetch(:branch)

    date = Time.now
    tagname = "v1-#{stage}-#{date.strftime('%Y-%m-%d-%H%M')}"

    # Delete all tags for respective stage.
    #oldtags = `git tag -l '#{stage}-*'`.split("\n")
    #oldtags.each { |tag| `git tag -d #{tag}` }

    # Push all the changes.
    #{}`git push --tags #{remote} :#{oldtags.join(' :')}`

    # Tag HEAD of respective branch.
    `git tag -a #{tagname} -m "Deployment of #{stage} at #{date.to_s}" #{branch}`
    `git push --tags #{remote} +#{tagname}`
  end
end
