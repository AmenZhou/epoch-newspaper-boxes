desc "generate sort number"
task :generate_sort_number, [:model_name] => [:environment] do |t, args|
  boroughs = args.model_name.constantize.pluck(:borough_detail).compact.uniq.sort
  borough_sort = {}
  boroughs.each_with_index do |b, index|
    borough_sort.update(b => index + 1)
  end
  args.model_name.constantize.all.each do |nb|
    nb.sort_num = borough_sort[nb.borough_detail]
    if nb.save
      print "."
    else
     puts "Errors --------- "
     p nb.errors
    end
  end
end
