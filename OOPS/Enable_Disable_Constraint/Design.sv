class my_class;
  rand int x, y;

  // Define named constraints
  constraint c_x { x inside {[1:20]}; }
  constraint c_y { y inside {[30:40]}; }
endclass

module sample;
  initial begin
    my_class m = new();

    m.randomize();
    $display("Default constraint: x=%0d y=%0d", m.x, m.y);

    m.c_x.constraint_mode(0); // Disable constraint on x
    m.randomize();
    $display("Constraint on x disabled: x=%0d y=%0d", m.x, m.y);

    m.c_x.constraint_mode(1); // Re-enable constraint on x
    m.randomize();
    $display("Constraint on x re-enabled: x=%0d y=%0d", m.x, m.y);
  end
endmodule
