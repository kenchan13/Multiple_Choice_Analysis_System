program readfile;
uses crt, sysutils, dos;
type
	StudentType = Record
			ID : string;
			Name : string;
			School : string;
			Mark : integer;
			Answer : string;
			Rank : integer;
         StandScore : real;
			end;
	SchoolType = Record
			Name : string;
         StudentID : array[0..30] of string;
			Freq : integer;
			Mark : integer;
			Rank : integer;
         Mean : real;
			end;
var
	Df : text;
	Student : array[0..30] of StudentType;
	School : array[1..10] of SchoolType;
	Answerfreq : array[1..50] of integer;
	numofile : integer;
   questnum : integer;
	count1, count2, count3 : integer;
	schoolnum : integer;
   mean : real;
   standev : real;
	ch : char;
   Year,Month,Day : word;

{=================The start of Background Procedure=================}
procedure inputans(filename : string);
var
	iNum : integer;
	code : integer;
begin
	{Assign files and input students' name, school and answers}
	assign(Df, 'E:\'+filename+'.txt');
	{$I-}
	reset(Df);
	{$I+}
	if (IOResult <> 0) then
	begin
		  writeln('Mmmm... Some files are missing. Exiting...');
		  readln;
	end else
	begin
	  val(filename, iNum, code);
	  with student[iNum] do
	  repeat
		 ID := filename;
		 readln(Df, Name);
		 readln(Df, School);
		 readln(Df, answer);
	  until eof(Df);
	end;
	close(Df);
end;

procedure filenum;
var
	files : string;
   code : integer;
begin
	  clrscr;
	  {Input the Num of file and change integer into string for filename}
	  writeln('Welcome! Thank you for using Multiple-Choice Analysis System!');
	  write('Please input the number of Participants:   ');
	  readln(files);
     val(files, numofile, code);
   while (numofile = 0) or (code <> 0) do
	  begin
			 writeln('Input error!');
			 write('Please input the number of Participants:   ');
			 readln(files);
          val(files, numofile, code);
	  end;

	  for count1 :=0 to numofile do
	  begin
		 str(count1, files);
		 inputans(files);
	  end;
end;

procedure checkans;
begin
	for count1 := 1 to questnum do
	begin
		  answerfreq[count1] := 0;
		  student[count1].mark := 0;
	end;

   {Find the number of question}
   for count1 := 1 to 50 do
       if student[0].answer[count1] = 'X' then
          questnum := count1 - 1;

	{Check students' answers and score}
	for count2 := 1 to numofile do
	with student[count2] do
	begin
		for count1 := 1 to questnum do
			if answer[count1] = student[0].answer[count1] then
			begin
				  mark := mark + 1;
				  answerfreq[count1] := answerfreq[count1] + 1;
			end;
	end;
end;

procedure studsort;
var
		  Ranking : array[1..10] of integer;
		  position : integer;
		  index : integer;
		  i : integer;
begin
	{Copy marks into var "ranking"}
	for count1 := 1 to numofile do
		 ranking[count1] := student[count1].mark;

	{Insertion Sort}
	 for count1 := 1 to numofile-1 do
	 begin
			index := Ranking[count1+1];
			position := 1;
			for i := 1 to count1 do
				 if index > Ranking[i]
					 then position := i + 1;

			for count3 := count1 downto position do
				 Ranking[count3+1] := Ranking[count3];

			Ranking[position] := index;
	 end;

	 {Compare the mark then input data to student.rank}
	 for count1 := 1 to numofile do
		  student[count1].rank := 0;

	 for count1 := 1 to numofile do
		  for count2 := 1 to numofile do
		  with student[count1] do
				if mark = ranking[count2] then
					rank := numofile - count2+ 1;
end;

procedure schoolfreq;
var
	Found : Boolean;
begin
	{initialization}
	for count1 := 1 to numofile do
	begin
		 School[count1].Name := '';
		 School[count1].Freq := 0;
		 School[count1].Mark := 0;
	end;
	schoolnum := 1;
	School[1].Name := Student[1].School;
   School[1].StudentID[1] := Student[1].ID;

	for count1 := 1 to numofile do
	begin
		 Found := FALSE; {initialization for FOUND}
		 for count2 := 1 to schoolnum do
			  if Student[count1].School = School[count2].Name then
				  begin
						 School[count2].Freq := School[count2].Freq + 1;
						 School[count2].Mark := School[count2].Mark + Student[count1].Mark;
                   {To link the relationship between school's data and student's data}
                   School[count2].StudentID[School[count2].Freq] := Student[count1].ID;
						 Found := TRUE;
				  end else
						 if (count2 = schoolnum) and (Found = FALSE) then
						 begin
								schoolnum := schoolnum + 1;
								School[schoolnum].Name := Student[count1].School;
								School[schoolnum].Mark := Student[count1].Mark;
                        {To link the relationship between school's data and student's data}
                        School[schoolnum].StudentID[1] := Student[count1].ID;
								School[schoolnum].Freq := 1;
						 end;
	end;
   for count1 := 1 to schoolnum do
   with school[count1] do
        mean := mark / freq;
end;

procedure schoolsort;
var
		  Ranking : array[1..10] of integer;
		  position : integer;
		  index : integer;
		  i : integer;
begin
	{Copy marks into var "ranking"}
	for count1 := 1 to schoolnum do
		 ranking[count1] := round(school[count1].mean*100);

	{Insertion Sort}
	 for count1 := 1 to schoolnum-1 do
	 begin
			index := Ranking[count1+1];
			position := 1;
			for i := 1 to count1 do
				 if index > Ranking[i]
					 then position := i + 1;

			for count3 := count1 downto position do
				 Ranking[count3+1] := Ranking[count3];

			Ranking[position] := index;
	 end;

	 {Compare the mark then input data to school.rank}
	 for count1 := 1 to schoolnum do
		  school[count1].rank := 0;

	 for count1 := 1 to schoolnum do
		  for count2 := 1 to schoolnum do
		  with school[count1] do
				if round(mean*100) = ranking[count2] then
					rank := schoolnum - count2+ 1;
end;

procedure statistics;
begin
     mean := 0;
     standev := 0;
     {Find Mean}
     for count1 := 1 to numofile do
         mean := mean + student[count1].mark;
     mean := mean / numofile;
     {Find standard deviation}
     for count1 := 1 to numofile do
         standev := sqr(student[count1].mark - mean) + standev;
     standev := sqrt(standev / numofile);
     for count1 := 1 to schoolnum do
     with school[count1] do
         mean := mark / freq;
end;

procedure start;
begin
	  filenum;
	  checkans;
	  studsort;
	  schoolfreq;
	  schoolsort;
     statistics;
end;
{=================The end of Background Procedures=================}
{=================The start of Visible Procedures=================}
procedure style;
begin
	  TextBackground(Blue);
	  TextColor(Yellow);
	  clrscr;
end;

procedure qanalysis;
var percent : integer;
    item : integer;
begin
	  style;
     gotoxy(33,5);writeln('Question Analysis');
	  gotoxy(23,7);writeln('Question', 'Freq':6, 'Answer': 10, 'Percentage': 13);
     item := 6;
     count2 := 0;
     repeat
	  for count1 := (item-5) to item do
	      begin
			  percent := answerfreq[count1] * 100 div numofile;
           count2 := count2 + 1;
		 	  gotoxy(26,7+count2);
           writeln(count1:5, answerfreq[count1]:6 , student[0].answer[count1]: 10, percent: 12,'%');
         end;
         gotoxy(26,9+count2);
         count2 := 0;
         item := item + 6;
         writeln('Press enter to continue.');
         ch := readkey;
     until (item >= questnum+6);
end;

procedure searchstu;
var target : string;
    found : Boolean;
begin
     clrscr;
     found := FALSE;
	  gotoxy(24,7);writeln('Please enter the participants'' full name.');
     gotoxy(24,8);readln(target);
     gotoxy(24,10);
     for count1 := 1 to numofile do
	  with student[count1] do
	  if target = name then
     begin
		  found := TRUE;
	     gotoxy(24,10);writeln('Name: ', name);
	     gotoxy(24,11);writeln('School: ', school);
	     gotoxy(24,12);writeln('Mark: ', mark);
	     gotoxy(24,13);writeln('Rank: ',rank);
     end;
	  if found = FALSE then writeln('Oops! No result can be shown.');
     gotoxy(24,15);
     writeln('Press enter to continue.');
     ch := readkey;
end;

procedure searchsch;
var target : string;
    found : Boolean;
begin
    clrscr;
	 gotoxy(24,7);writeln('Please enter the schools'' full name.');
    gotoxy(24,8);readln(target);
    gotoxy(24,10);
    found := FALSE;
    for count1 := 1 to schoolnum do
    with school[count1] do
    if target = name then
	 begin
	   found := TRUE;
      gotoxy(24,10);writeln('Name: ', name);
		gotoxy(24,11);writeln('No. of participants: ', freq);
		gotoxy(24,12);writeln('Mark: ', mark);
		gotoxy(24,13);writeln('Rank: ',rank);

      {Shows all participants inside the school}
      gotoxy(24,15);writeln('Student');
      gotoxy(24,16);writeln('ID':2, 'Name':20, 'Mark':6, 'Rank':6);
      for count2 := 1 to freq do
          begin
             gotoxy(24,17+count2);
             write(school[count1].studentID[count2]:2);
             with student[count2] do
             writeln(Name:20, Mark:6, Rank:6);
          end;

	end;
   if found = FALSE then writeln('Oops! No result can be shown.');
   ch := readkey;
end;

procedure search;
begin
	  style;
	  gotoxy(34,5);writeln('Searching');
     gotoxy(28,7);writeln('1. Participant');
     gotoxy(28,8);writeln('2. School');
     ch := readkey;
     if ch = '1' then searchstu else
        if ch = '2' then searchsch;
end;

procedure performance;
var item : integer;
begin
	 style;
	 gotoxy(37,5); writeln('Performance');
	 gotoxy(30,7); writeln('Participants'' Performance');
	 gotoxy(15,8); writeln('No. of participants: ', numofile);
    gotoxy(15,9); writeln('No. of participating schools: ',schoolnum);
    gotoxy(15,10);writeln('Mean: ',mean :0:1);
    gotoxy(15,11);writeln('Standard deviation: ', standev :0:1);

	 {Output result of student}
	 gotoxy(15,13); writeln('Name':15, 'Mark':6, 'School':15, 'Rank':6);
    item := 7;
    count2 := 0;
    repeat
      for count1 := (item-6) to item do
      with student[count1] do
      begin
         count2 := count2 + 1;
	      gotoxy(15,13 + count2);
         write(Name :15, Mark :6, School :15, Rank :6);
      end;
      item := item + 7;
      gotoxy(15,14 + count2);
      count2 := 0;
      writeln('Press enter to continue.');
      ch := readkey;
    until item >= numofile+7;

	  {Output result of school}
     clrscr;
     gotoxy(32,5); writeln('School''s Performance');
     gotoxy(7,7);writeln('Name':20, 'Mark':6, 'No. of Participants':20, 'Mean':6, 'Rank':6);
	  for count1 := 1 to schoolnum do
	  with School[count1] do
	  begin
        gotoxy(7,7+count1);
        writeln(Name:20, Mark:6, Freq:20, Mean:6:1, Rank:6);
	  end;
     gotoxy(20,10+count1);
     writeln('Press enter to continue.');
     ch := readkey;
end;

procedure prize;
begin
		style;
		gotoxy(40,5); write('Prize');
		gotoxy(15,8);write('Individual Awards');
      count2 := 0;

      for count1 := 1 to numofile do
      with student[count1] do
      if rank = 1 then
         begin
           count2 := count2 + 1;
           gotoxy(15, 8 + count2);
           write('Champion       ', name);
         end else if rank = 2 then
         begin
            count2 := count2 + 1;
            gotoxy(15, 8 + count2);
            write('1st runner up  ', name);
         end else if rank = 3 then
         begin
            count2 := count2 + 1;
            gotoxy(15, 8 + count2);
            write('2nd runner up  ', name);
         end;

      gotoxy(15,13);write('School Awards');
      count2 := 0;
      for count1 := 1 to numofile do
      with school[count1] do
      if rank = 1 then
         begin
           count2 := count2 + 1;
           gotoxy(15, 13 + count2);
           write('Champion       ', name);
         end else if rank = 2 then
         begin
            count2 := count2 + 1;
            gotoxy(15, 13 + count2);
            write('1st runner up  ', name);
         end else if rank = 3 then
         begin
            count2 := count2 + 1;
            gotoxy(15, 13 + count2);
            write('2nd runner up  ', name);
         end;

      gotoxy(15,19);
      writeln('Press enter to continue.');
      ch := readkey;
end;

procedure exportresult;
var   percent : integer;
      f1, f2, f3 : string;
begin
   str(Year, f1);
   str(Month, f2);
   str(Day, f3);
	assign(Df, 'E:\'+f1+f2+f3+'Result.txt');
	rewrite(Df);
   writeln (Df, 'Time: ',DateTimeToStr(Now));
	writeln(Df, 'Performance');
	writeln(Df, 'No. of participants: ', numofile);
   writeln(Df, 'No. of participating schools: ', schoolnum);
   writeln(Df, 'Mean: ',mean :0:1);
   writeln(Df, 'Standard deviation: ', standev :0:1);

	{Output ranking of student}
	writeln(Df, 'Participants'' Performance');
	writeln(Df,'Name':15, 'Mark':6, 'School':15, 'Rank':6);
	for count1 := 1 to numofile do
   with student[count1] do
        writeln(Df, Name :15, Mark :6, School :15, Rank :6);
   writeln(Df);
   writeln(Df, 'School''s Performance');
   writeln(Df, 'Name':15, 'Mark':6, 'No. of Participants':20, 'Mean':6, 'Rank':6);
	for count1 := 1 to schoolnum do
	with School[count1] do
   writeln(Df, Name:15, Mark:6, Freq:20, Mean:6:1, Rank:6);

	writeln(Df);
	writeln(Df, 'Prize');
	writeln(Df, 'Individual Awards');
	for count1 := 1 to numofile do
	    with student[count1] do
		 case rank of
	    1 : writeln(Df, 'Champion':15, name:20);
		 2 : writeln(Df, '1st runner up':15, name:20);
		 3 : writeln(Df, '2nd runner up':15, name:20);
		 end;

      writeln(Df);
		writeln(Df, 'School Awards');
		for count1 := 1 to schoolnum do
		with school[count1] do
			case rank of
			1 : writeln(Df, 'Champion':15, name:15);
			2 : writeln(Df, '1st runner up':15, name:15);
			3 : writeln(Df, '2nd runner up':15, name:15);
			end;

      writeln(Df);
      writeln(Df, 'Question Analysis');
	   writeln(Df, 'Question', 'Freq':6, 'Answer': 10, 'Percentage': 13);
	   for count1 := 1 to questnum do
	       begin
		 	    percent := answerfreq[count1] * 100 div numofile;
             writeln(Df, count1:5, answerfreq[count1]:6 , student[0].answer[count1]: 10, percent: 12,'%');
	       end;
	close(Df);
   clrscr;
   gotoxy(31,9);
   writeln('The file is exported!');
   delay(3000);  {UI}
end;

procedure mainpage;
begin
	  style;
     DeCodeDate (Date,Year,Month,Day);
     writeln ('Time: ',DateTimeToStr(Now));
     gotoxy(24,09); writeln('Multiple-Choice Analysis System');
	  gotoxy(28,11); writeln('1. Question Analysis');
	  gotoxy(28,12); writeln('2. Searching');
	  gotoxy(28,13); writeln('3. Performance');
	  gotoxy(28,14); writeln('4. Prize');
     gotoxy(28,15); writeln('5. Exporting Result');
	  gotoxy(28,16); writeln('Press ''Q'' to exit.');
     gotoxy(28,17);

	  ch := readkey;
	  case ch of
	  '1' : qanalysis;
	  '2' : search;
	  '3' : performance;
	  '4' : prize;
	  '5' : exportresult;
	  'Q', 'q' : writeln('You now exit the system.');
	  else mainpage;
	  end;
end;
{=================The end of Visible Procedures=================}

begin
	start;
	repeat
			mainpage;
	until (ch = 'q') or (ch = 'Q');
	READLN;
end.
