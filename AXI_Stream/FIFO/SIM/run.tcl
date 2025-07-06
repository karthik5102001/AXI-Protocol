
set DUT "Enter Location of DUT file here"
set TB "Enter Location of TB file here"


puts "Running VCS compilation..."
if {[catch {exec vcs -full64 -sverilog -debug_access+all $DUT $TB} result]} {
    puts "Error during VCS compilation: $result"
    exit 1
} else {
    puts "VCS compilation successful."
}

after 100

puts "Running Sim"
if {[catch {exec ./simv -gui=verdi & } result]} {
    puts "Error during SIMV compilation: $result"
    exit 1
} else {
    puts "SIMV compilation successful."
}

after 1000

puts "Running Verdi"
if {[catch {exec  verdi -ssf APB_REG.vcd & } result]} {
    puts "Error during SIMV compilation: $result"
    exit 1
} else {
    puts "Verdi compilation successful."
}
