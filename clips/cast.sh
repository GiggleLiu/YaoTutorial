julia --project=. -e "using AsciinemaGenerator; cast_file(\"$1.jl\"; output_file=\"$1.cast\", output_row_delay=0.0001, mod=Main)"
asciinema play $1.cast
