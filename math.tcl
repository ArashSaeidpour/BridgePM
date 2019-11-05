 # math.tcl --
 #
 #      Collection of math functions.
 #
 
 package provide math 1.0
 
 namespace eval ::math {
 }
 
 # ::math::min --
 #
 #      Return the minimum of two or more values
 #
 # Arguments:
 #      val     first value
 #      args    other values
 #
 # Results:
 #      min     minimum value
 
 proc ::math::min {val args} {
     set min $val
     foreach val $args {
        if { $val < $min } {
            set min $val
        }
     }
     set min
 }
 
 # ::math::max --
 #
 #      Return the maximum of two or more values
 #
 # Arguments:
 #      val     first value
 #      args    other values
 #
 # Results:
 #      max     maximum value
 
 proc ::math::max {val args} {
     set max $val
     foreach val $args {
        if { $val > $max } {
            set max $val
        }
     }
     set max
 }
 
 # ::math::sum --
 #
 # Return the sum of one or more values
 #
 # Arguments:
 #    val first value
 #    args all other values
 #
 # Results:
 #    sum  arithmetic sum of all values in args
 
 proc ::math::sum {val args} {
      set sum $val
      foreach val $args {
         set sum [ expr { $sum+$val } ]
      }
      set sum
 }
 
 
 # ::math::mean --
 #
 # Return the mean of two or more values
 #
 # Arguments:
 #    val  first value
 #    args other values
 #
 # Results:
 #    mean  arithmetic mean value
 
 proc ::math::mean {val args} {
      set sum $val
      set N [ expr { [ llength $args ] + 1 } ]
      foreach val $args {
         set sum [ expr { $sum+$val } ]
      }
      set mean [ expr { $sum/$N } ]
      set mean
 }
 
 ## A helper function...
 ## Note that this is the heart of why the improved versions are better
 ## since it allows you to only make a single pass through the data.
 proc ::math::SumSum2 {list} {
     set sum  0.0
     set sum2 0.0
     foreach x $list {
         set sum  [expr {$sum  + $x}]
         set sum2 [expr {$sum2 + $x*$x}]
     }
     list $sum $sum2
 }

 # ::math::sigma --
 #
 # Return the standard deviation of three or more values
 #
 # Arguments:
 #    val1 first value
 #    val2 second value
 #    args other values
 #
 # Results:
 #    sigma  population standard deviation value
 
 proc ::math::sigma {val1 val2 args} {
      # More efficient to build list before using concat...
      set args [concat [list $val1 $val2] $args]
      foreach {sum sum2} [SumSum2 $args] {}
      set N [llength $args]
      set mean [expr {$sum/$N}]
      set sigma2 [expr {($sum2 - $mean*$mean*$N)/($N-1)}]
      return [expr {sqrt($sigma2)}]

      ### Old Algorithm Follows
      #set sum [ expr { $val1+$val2 } ]
      #set N [ expr { [ llength $args ] + 2 } ]
      #foreach val $args {
      #   set sum [ expr { $sum+$val } ]
      #}
      #set mean [ expr { $sum/$N } ]
      #set sigma_sq 0
      #foreach val [ concat $val1 $val2 $args ] {
      #   set sigma_sq [ expr { $sigma_sq+pow(($val-$mean),2) } ]
      #}
      #set sigma_sq [ expr { $sigma_sq/($N-1) } ] 
      #set sigma [ expr { sqrt($sigma_sq) } ]
      #set sigma
 }     
 
 # ::math::cov --
 #
 # Return the coefficient of variation of three or more values
 #
 # Arguments:
 #    val1 first value
 #    val2 second value
 #    args other values
 #
 # Results:
 #    cov  coefficient of variation expressed as percent value
 
 proc ::math::cov {val1 val2 args} {
      set args [concat [list $val1 $val2] $args]
      foreach {sum sum2} [SumSum2 $args] {}
      set N [llength $args]
      set mean [expr {$sum/$N}]
      set sigma2 [expr {($sum2 - $N*$mean*$mean)/($N-1)}]
      set sigma [expr {sqrt($sigma2)}]
      return [expr {($sigma/$mean)*100}]

      ### Old Algorithm
      #set sum [ expr { $val1+$val2 } ]
      #set N [ expr { [ llength $args ] + 2 } ]
      #foreach val $args {
      #   set sum [ expr { $sum+$val } ]
      #}
      #set mean [ expr { $sum/$N } ]
      #set sigma_sq 0
      #foreach val [ concat $val1 $val2 $args ] {
      #   set sigma_sq [ expr { $sigma_sq+pow(($val-$mean),2) } ]
      #}
      #set sigma_sq [ expr { $sigma_sq/($N-1) } ] 
      #set sigma [ expr { sqrt($sigma_sq) } ]
      #set cov [ expr { ($sigma/$mean)*100 } ]
      #set cov
 }
 
 proc ::math::stats {val1 val2 args} {
      set args [concat [list $val1 $val2] $args]
      foreach {sum sum2} [SumSum2 $args] {}
      set N [llength $args]
      set mean [expr {$sum/$N}]
      set sigma2 [expr {($sum2 - $N*$mean*$mean)/($N-1)}]
      set sigma [expr {sqrt($sigma2)}]
      return [list $mean $sigma [expr {($sigma/$mean)*100}]]

      ### Old Algorithm
      #set sum [ expr { $val1+$val2 } ]
      #set N [ expr { [ llength $args ] + 2 } ]
      #foreach val $args {
      #   set sum [ expr { $sum+$val } ]
      #}
      #set mean [ expr { $sum/$N } ]
      #set sigma_sq 0
      #foreach val [ concat $val1 $val2 $args ] {
      #   set sigma_sq [ expr { $sigma_sq+pow(($val-$mean),2) } ]
      #}
      #set sigma_sq [ expr { $sigma_sq/($N-1) } ] 
      #set sigma [ expr { sqrt($sigma_sq) } ]
      #set cov [ expr { ($sigma/$mean)*100 } ]
      #return [ list $mean $sigma $cov ]
 }
 
 # ::math::prod --
 #
 # Return the product of one or more values
 #
 # Arguments:
 #    val first value
 #    args other values
 #
 # Results:
 #    prod  product of multiplying all values in the list
 
 proc ::math::prod {val args} {
      set prod $val
      foreach val $args {
         set prod [ expr { $prod*$val } ]
      }
      set prod
 }