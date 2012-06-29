class CountdownCollectionTableViewCell < UITableViewCell

  attr_accessor :countdown

  def self.cell
    cell = self.alloc.initWithStyle(
      UITableViewCellStyleSubtitle,
      reuseIdentifier: self.to_s)
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator
    cell.editingAccessoryType = UITableViewCellAccessoryDisclosureIndicator
    cell.selectionStyle = UITableViewCellSelectionStyleGray
    cell.hidesAccessoryWhenEditing = false

    cell
  end

  def countdown= newCountdown
    @countdown = newCountdown
    endDate = countdown.endDate

    if countdown.name.to_s.empty?
      textLabel.text = endDate.to_s
      detailTextLabel.text = nil
    else
      textLabel.text = countdown.name
      detailTextLabel.text = endDate.to_s
    end

    if endDate < CountdownDate.now
      textLabel.color = UIColor.grayColor
    else
      textLabel.color = UIColor.blackColor
    end

  end

end
