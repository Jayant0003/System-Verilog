// Code your testbench here
// or browse Examples
module test;
class prime_number;
    rand int a[], b[$];
    constraint abc { a.size == 200; }
    constraint cba { foreach (a[i]) a[i] == prime(i); }

    function int prime(int g);
        if (g <= 1) return 2;
        for (int i = 2; i < g; i++)
            if (g % i == 0) return 2; // If it's not a prime number, return 2 (which is one of the primes)
        prime = g;
    endfunction

    function void post_randomize();
        a.unique;
        for (int i = 0; i < a.size; i++) begin
            if (a[i] % 10 == 7)
                b.push_back(a[i]); // In queue 'b', you'll find prime numbers with units place as 7.
        end
    endfunction
endclass

prime_number pri;

initial begin
    pri = new;
    assert(pri.randomize);
    $display("%0p", pri.b);
end
endmodule
