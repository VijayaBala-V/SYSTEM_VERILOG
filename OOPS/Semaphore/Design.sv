module semaphore_example;

  semaphore s;

  initial begin
    // Initialize the semaphore with 1 key (binary semaphore)
    s = new(1);

    // Start both processes concurrently
    fork
      process_a();
      process_b();
    join
  end

  task process_a();
    $display("[%0t] process A: waiting for semaphore...", $time);
    s.get(1); // Wait to acquire semaphore
    $display("[%0t] process A: got semaphore, using resource...", $time);
    #5;
    $display("[%0t] process A: releasing semaphore...", $time);
    s.put(1); // Release semaphore
  endtask

  task process_b();
    $display("[%0t] process B: waiting for semaphore...", $time);
    s.get(1); // Wait to acquire semaphore
    $display("[%0t] process B: got semaphore, using resource...", $time);
    #5;
    $display("[%0t] process B: releasing semaphore...", $time);
    s.put(1); // Release semaphore
  endtask

endmodule
