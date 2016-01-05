#!/usr/bin/perl -w

sub left_delete_zero_from_queue {
    my ($queue_ref,$ret_queue_ref) = @_;
    my $head;
    $head = shift(@$queue_ref);
    #print "head = $head\n";
    if(!defined($head)) {
    }
    else {
        if($head eq 0) {}
        else {
            push(@$ret_queue_ref,$head);
        }
        left_delete_zero_from_queue($queue_ref,$ret_queue_ref);
    }
}

sub left_move_merge_from_queue {
    my ($queue_ref,$ret_queue_ref) = @_;
    my $self_num = shift(@$queue_ref);
    #print "self_num = $self_num\n";
    my $right_neighbor = shift(@$queue_ref);
    #print "right_neighbor = $right_neighbor\n";
    if(!defined($self_num)) {
        #print "1\n";
        #end
    }
    elsif(!defined($right_neighbor)) {
        push(@$ret_queue_ref,$self_num);
        #print "2\n";
        #end
    }
    else {
        if($self_num eq $right_neighbor) {
            $self_num += $self_num;
            #print "3\n";
            push(@$ret_queue_ref,$self_num);
            left_move_merge_from_queue($queue_ref,$ret_queue_ref);
        }
        else {
            #print "4\n";
            push(@$ret_queue_ref,$self_num);
            unshift(@$queue_ref,$right_neighbor);
            left_move_merge_from_queue($queue_ref,$ret_queue_ref);
        }
        #end
    }
}

sub table_has_place {
    my $table = shift;
    my $xy_queue_empty_ref;
    my $has_empty_cell = 0;
    my $row_ref;
    my $column;
    my $x = 0;
    my $y = 0; #x-y coordinate
    foreach $row_ref (@$table) {
        $y = 0;
        foreach $column (@$row_ref) {
            if($column eq 0) {
                push(@$xy_queue_empty_ref,"$x,$y");
            }
            $y++;
        }
        $x++;
    }
    $xy_queue_empty_ref;
}

sub add_one_randomize_data {
    my $table = shift;
    my $xy_queue_empty_ref;
    $xy_queue_empty_ref = table_has_place($table);
    if(defined($xy_queue_empty_ref)) {
        my $empty_num = scalar(@$xy_queue_empty_ref);
        my $rand_pos = (int rand($width*$width))%($empty_num);
        my ($x,$y) = split /,/,$xy_queue_empty_ref->[$rand_pos];
        my $add_two = (int rand(6))%2;
        #print "empty_num = $empty_num\n";
        #print "rand_pos = $rand_pos\n";
        #print "x,y = ($x,$y)\n";
        #print "add_two = $add_two\n";
        $table->[$x][$y] = ($add_two ? 2:4);
    }
    else {
        print "No place!\n";
        print "Game over!\n";
        exit(0);
    }
}

sub show_table {
    my $table = shift;
    my $row;
    my $column;
    #print "show table:\n";
    foreach $row (@$table) {
        my @queue;
        foreach $column (@$row) {
            push(@queue,$column);
        }
        print "@queue\n";
    }
    #print "show table end.\n";
}

sub debug_show {
    my $table = shift;
    my $i;
    my $j;
    print "debug show:\n";
    for($i=0;$i<$width;$i++) {
        for($j=0;$j<$width;$j++) {
            print "$table->[$i][$j] ";
        }
        print "\n";
    }
    print "debug show end.\n";
}

sub initialize_table {
    my $i;
    my $j;
    for($i=0;$i<$width;$i++) {
        for($j=0;$j<$width;$j++) {
            $a_ref->[$i][$j] = 0;
            #print "i = $i, j = $j\n";
        }
    }
    #debug show
    #debug_show($a_ref);
    #show_table($a_ref);
    my $num; #times of randomization, 2 or 3 times
    $num = (int rand(6))%2 + 2;
    while($num > 0) {
        $num--;
        add_one_randomize_data($a_ref);
    }
    show_table($a_ref);
}

sub get_stdin_movement {
    my $move = shift;
    chomp($move);
    my $ret;
    if($move eq "a") {
        $ret = "left";
    }
    elsif($move eq "d") {
        $ret = "right";
    }
    elsif($move eq "w") {
        $ret = "up";
    }
    elsif($move eq "s") {
        $ret = "down";
    }
    else {
        print "Please input a,d,w or s\n";
        print "a means left, d means right, w means up, s means down\n";
    }
    $ret;
}

sub counter_clock_wise90 {
    my $table = shift;
    my $ret_table = [[]];
    my $row;
    my $column;
    my $i;
    my $j;
    for($i=0;$i<$width;$i++) {
        for($j=0;$j<$width;$j++) {
            $ret_table->[$i][$j] = $table->[$j][$width-1-$i];
        }
    }
    $ret_table;
}

sub up_to_left {
    my $table = shift;
    my $ret_table = [[]];
    $ret_table = counter_clock_wise90($table);
    $ret_table;
}

sub left_to_up {
    my $table = shift;
    my $ret_table = [[]];
    $ret_table = counter_clock_wise90($table);
    $ret_table = counter_clock_wise90($ret_table);
    $ret_table = counter_clock_wise90($ret_table);
    $ret_table;
}

sub down_to_left {
    my $table = shift;
    my $ret_table = [[]];
    $ret_table = counter_clock_wise90($table);
    $ret_table = counter_clock_wise90($ret_table);
    $ret_table = counter_clock_wise90($ret_table);
    $ret_table;
}

sub left_to_down {
    my $table = shift;
    my $ret_table = [[]];
    $ret_table = counter_clock_wise90($table);
    $ret_table;
}

sub right_to_left {
    my $table = shift;
    my $ret_table = [[]];
    $ret_table = counter_clock_wise90($table);
    $ret_table = counter_clock_wise90($ret_table);
    $ret_table;
}

sub left_to_right {
    my $table = shift;
    my $ret_table = [[]];
    $ret_table = counter_clock_wise90($table);
    $ret_table = counter_clock_wise90($ret_table);
    $ret_table;
}

sub cells_rotate_to_left {
    my $table = shift;
    my $ret_table = [[]];
    if($movement eq "left") {
        $ret_table = $table;
    }
    elsif($movement eq "up") {
        $ret_table = up_to_left($table);
    }
    elsif($movement eq "down") {
        $ret_table = down_to_left($table);
    }
    elsif($movement eq "right") {
        $ret_table = right_to_left($table);
    }
    else {
        die "This branch should never happen!:$!";
    }
    $ret_table;
}

sub cells_rotate_to_original {
    my $table = shift;
    my $ret_table = [[]];
    if($movement eq "left") {
        $ret_table = $table;
    }
    elsif($movement eq "up") {
        $ret_table = left_to_up($table);
    }
    elsif($movement eq "down") {
        $ret_table = left_to_down($table);
    }
    elsif($movement eq "right") {
        $ret_table = left_to_right($table);
    }
    else {
        die "This branch should never happen!:$!";
    }
    $ret_table;
}

sub cells_fill_queues {
    my $table = shift;
    my ($i,$j);
    for($i=0;$i<$width;$i++) {
        for($j=0;$j<$width;$j++) {
           push(@{$queues->[$i]},$table->[$i][$j]);
        }
    }
}

sub queues_fill_cells {
    my $ret_table = [[]];
    my ($i,$j);
    for($i=0;$i<$width;$i++) {
        for($j=0;$j<$width;$j++) {
            my $item = shift(@{$queues->[$i]});
            if(defined($item)) {
                $ret_table->[$i][$j] = $item;
            }
            else {
                $ret_table->[$i][$j] = 0;
            }
        }
    }
    $ret_table;
}

sub move_queues {
    my $i;
    for($i=0;$i<$width;$i++) {
        my $queue_tmp = [];
        left_delete_zero_from_queue($queues->[$i],$queue_tmp);
        left_move_merge_from_queue($queue_tmp,$queues->[$i]);
    }
}

sub change_table_due_to_move {
    $a_ref = cells_rotate_to_left($a_ref);
    cells_fill_queues($a_ref);
    move_queues();
    $a_ref = queues_fill_cells();
    $a_ref = cells_rotate_to_original($a_ref);
}

BEGIN {
#global vars
$width = 4;
$a_ref = [[]]; #default table
$movement = "left";  #default movement is "move to the left"
$queues = [[]]; # $queues->[0] to access the first queue, ... , $queues->[$width-1] to access the last queue
}

#initialize
initialize_table(); # randomize and generates two or three 2/4;

print "Let's Start!\n";
print "Please input a,d,w or s\n";
print "a means left, d means right, w means up, s means down\n";
while (<>) {
    #print "you input is $_";
    my $tmp = get_stdin_movement($_);
    if(!defined($tmp)) {
        next;
    }
    else {
        $movement = $tmp;
        #print "normal\n";
    }
    change_table_due_to_move();
    #show_table($a_ref);
    add_one_randomize_data($a_ref);
    show_table($a_ref);
}
