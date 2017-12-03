/* inventory smell_type */
BEGIN
    new_smell_type('01', 'Good');
    new_smell_type('02', 'Neutral');
    new_smell_type('03', 'Bad');

END;
/


/* inventory smell_magnitude */
BEGIN
    new_smell_magnitude('01', '{DESC1}', 0.1);
    new_smell_magnitude('02', '{DESC2}', 0.2);
    new_smell_magnitude('03', '{DESC3}', 0.3);
    new_smell_magnitude('04', '{DESC4}', 0.4);
    new_smell_magnitude('05', '{DESC5}', 0.5);
    new_smell_magnitude('06', '{DESC6}', 0.6);
    new_smell_magnitude('07', '{DESC7}', 0.7);
    new_smell_magnitude('08', '{DESC8}', 0.8);
    new_smell_magnitude('09', '{DESC9}', 0.9);
    new_smell_magnitude('10', '{DESC10}', 1.0);
    
END;
/