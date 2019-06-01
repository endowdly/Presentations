



// Here is a rough equivalent of our PowerShell example as a LINQ expression.

DateTime result = input
    .Where(x => x.freq >= 10)
    .Where(x => x.type == 'RX')
    .OrderbyDescending(x => x.freq)
    .Select(x => new DateTime(x.date));