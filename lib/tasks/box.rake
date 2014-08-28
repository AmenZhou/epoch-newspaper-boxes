desc "generate sort number"
task generate_sort_number: :environment do
  boroughs = NewspaperBox.pluck(:borough_detail).compact.uniq.sort
  borough_sort = {}
  boroughs.each_with_index do |b, index|
    borough_sort.update(b => index + 1)
  end
  NewspaperBox.all.each do |nb|
    nb.sort_num = borough_sort[nb.borough_detail]
    if nb.save
      print "."
    else
     puts "Errors --------- "
     p nb.errors
    end
  end
end