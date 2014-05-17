requires 'perl', '5.008001';
requires 'Email::Sender::Simple', '0';
requires 'Email::Simple', '0';
requires 'Email::Simple::Creator', '0';
requires 'Data::Recursive::Encode','0';
requires 'Ukigumo::Common', '0.09';
requires 'Mouse', '0';


on 'test' => sub {
    requires 'Test::More', '0.98';
};

