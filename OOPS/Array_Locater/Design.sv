// Code your testbench here
// or browse Examples
typedef enum {RED, GREEN, YELLOW} color_type;
class transaction;
  rand bit [2:0] addr;
  rand bit [2:0] data;
  rand color_type colors; 
  
  function void print;
    $display("addr = %0d, data = %0d and color = %s", addr, data, colors.name);
  endfunction
endclass

module elememt_arr_locator_ex;
  transaction tr;
  transaction tr_assoc_arr[int];
  int arr[8] = '{5,6,9,2,3,4,6,10};
  
  initial begin
    $display("-------------------------------------");
    $display("--------- Generating array ----------");
    $display("-------------------------------------");
    array_gen();
    $display("-------------------------------------");
    $display("------------- find method -----------");
    $display("-------------------------------------");
    find_method();
    $display("-------------------------------------");
    $display("--------- find_first method ---------");
    $display("-------------------------------------");
    find_first_method();
    $display("-------------------------------------");
    $display("--------- find_last method ----------");
    $display("-------------------------------------");
    find_last_method();
    $display("-------------------------------------");
    $display("---------- unique method ------------");
    $display("-------------------------------------");
    unique_method();
    $display("-------------------------------------");
    $display("---------- min max method -----------");
    $display("-------------------------------------");
    min_max_method();
  end
  
  
  //-------------------------
  // Array gen and methods
  //-------------------------
  
  function void array_gen();
    tr = new();
    assert(tr.randomize());
    tr.print();
    tr_assoc_arr[3] =  tr;
    
    tr = new();
    assert(tr.randomize());
    tr.print();
    tr_assoc_arr[5] =  tr;
    
    tr = new();
    assert(tr.randomize());
    tr.print();
    tr_assoc_arr[8] =  tr;
    
    tr = new();
    assert(tr.randomize());
    tr.print();
    tr_assoc_arr[11] =  tr;
    
    tr = new();
    assert(tr.randomize());
    tr.print();
    tr_assoc_arr[15] =  tr;
  endfunction
  
  function void find_method();
    transaction tr_q[$], tr;
    int qsize;
    
    // Find all elements having item as YELLOW color
    tr_q = tr_assoc_arr.find with (item.colors == YELLOW);
    qsize = tr_q.size;
    $display("Number of elements for color item 'YELLOW' = %0d", qsize);
    
    for(int i = 0; i < qsize; i++) begin
      $display("Element %0d: ",i+1);
      tr = tr_q.pop_front();
      tr.print();
    end
    
    // expression has multiple conditions
    tr_q = tr_assoc_arr.find with (item.data >= 1 && item.data <= 5);
    qsize = tr_q.size;
    $display("\nNumber of elements for data item in range of 1 to 5 = %0d", qsize);
    
    for(int i = 0; i < qsize; i++) begin
      $display("Element %0d: ",i+1);
      tr = tr_q.pop_front();
      tr.print();
    end
  endfunction
  
  function void find_first_method();
    transaction tr_q[$], tr;
    int qsize;
    
    // Find first element having item as YELLOW color
    tr_q = tr_assoc_arr.find_first with (item.colors == YELLOW);
    qsize = tr_q.size;
    $display("Number of elements for color item 'YELLOW' = %0d", qsize);
    
    for(int i = 0; i < qsize; i++) begin
      $display("Element %0d: ",i+1);
      tr = tr_q.pop_front();
      tr.print();
    end
    
    // expression has multiple conditions
    tr_q = tr_assoc_arr.find_first with (item.data >= 1 && item.data <= 5);
    qsize = tr_q.size;
    $display("\nNumber of elements for data item in range of 1 to 5 = %0d", qsize);
    
    for(int i = 0; i < qsize; i++) begin
      $display("Element %0d: ",i+1);
      tr = tr_q.pop_front();
      tr.print();
    end
  endfunction
  
  function void find_last_method();
    transaction tr_q[$], tr;
    int qsize;
    
    // Find last element having item as YELLOW color
    tr_q = tr_assoc_arr.find_last with (item.colors == YELLOW);
    qsize = tr_q.size;
    $display("Number of elements for color item 'YELLOW' = %0d", qsize);
    
    for(int i = 0; i < qsize; i++) begin
      $display("Element %0d: ",i+1);
      tr = tr_q.pop_front();
      tr.print();
    end
    
    // expression has multiple conditions
    tr_q = tr_assoc_arr.find_last with (item.data >= 1 && item.data <= 5);
    qsize = tr_q.size;
    $display("\nNumber of elements for data item in range of 1 to 5 = %0d", qsize);
    
    for(int i = 0; i < qsize; i++) begin
      $display("Element %0d: ",i+1);
      tr = tr_q.pop_front();
      tr.print();
    end
  endfunction
  
  function void unique_method();
    transaction tr_q[$], tr;
    int arr_q[$];
    int qsize;
    
    arr_q = arr.unique();
    $display("unique element in arr = %p", arr_q);
    
    // Find unique elements of addr.
    tr_q = tr_assoc_arr.unique with (item.addr);
    qsize = tr_q.size;
    $display("Number of unique elements for addr = %0d", qsize);
    
    for(int i = 0; i < qsize; i++) begin
      $display("Element %0d: ",i+1);
      tr = tr_q.pop_front();
      tr.print();
    end
  endfunction
  
  function void min_max_method();
    transaction tr_q[$], tr;
    int arr_q[$];
    int qsize;
    
    // Find min and max element in an array
    arr_q = arr.min;
    $display("min element in arr = %p", arr_q);
    arr_q = arr.max;
    $display("max element in arr = %p", arr_q);
    
    tr_q = tr_assoc_arr.min with (item.addr);
    qsize = tr_q.size;
       
    for(int i = 0; i < qsize; i++) begin
      $display("Min element w.r.t. addr is ");
      tr = tr_q.pop_front();
      tr.print();
    end
    
    tr_q = tr_assoc_arr.max with (item.addr);
    qsize = tr_q.size;
       
    for(int i = 0; i < qsize; i++) begin
      $display("Max element w.r.t. addr is ");
      tr = tr_q.pop_front();
      tr.print();
    end
  endfunction
endmodule
