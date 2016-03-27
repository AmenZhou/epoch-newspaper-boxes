class History < ActiveRecord::Base
  EpochBranchName = ['New York', 'New Jersey', 'San Francisco']

  def self.daily_report
    EpochBranchName.each do |epoch_branch|
      epoch_branch = EpochBranch.find_by_name(epoch_branch)
      #Newspaper Box
      newspaper = NewspaperBox.where(epoch_branch: epoch_branch)
      create_history_by_newspaper(newspaper, epoch_branch.id, 'NewspaperBox')
      #Newspaper Hand
      newspaper = NewspaperHand.where(epoch_branch: epoch_branch)
      create_history_by_newspaper(newspaper, epoch_branch.id, 'NewspaperHand')
    end
  end

  def self.create_history_by_newspaper(newspaper, epoch_branch_id, newspaper_type)
    attr = {}
    #Calc weekly newspaper amount
    attr[:newspaper] = newspaper.inject(0){ |sum, np| sum += np.week_count }
    attr[:box] = newspaper.count
    attr[:box_type] = newspaper_type
    attr[:epoch_branch_id] = epoch_branch_id
    history = History.new(attr)
    if history.save
      File.open('log/history.log', 'w') do |f|
        f.write "Save a #{model_name} history record success"
      end
    else
      File.open('log/history.log', 'w') do |f|
        f.write "Error: Save a #{model_name} history record failed"
      end
    end
  end
end
