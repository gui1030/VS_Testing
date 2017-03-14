$(() => {
    $('#phone').keyup((e) => {
      // Remove invalid chars from the input
      var input = e.currentTarget.value.replace(/[^0-9\(\)\s\-]/g, "");
      var inputlen = input.length;
      // Get just the numbers in the input
      var numbers = e.currentTarget.value.replace(/\D/g,'');
      var numberslen = numbers.length;
      // Value to store the masked input
      var newval = "";

      // Loop through the existing numbers and apply the mask
      for(var i=0;i<numberslen;i++){
        if(i==0) newval="("+numbers[i];
        else if(i==3) newval+=") "+numbers[i];
        else if(i==6) newval+="-"+numbers[i];
        else newval+=numbers[i];
      }

      // Re-add the non-digit characters to the end of the input that the user entered and that match the mask.
      if(inputlen>=1&&numberslen==0&&input[0]=="(") newval="(";
      else if(inputlen>=6&&numberslen==3&&input[4]==")"&&input[5]==" ") newval+=") ";
      else if(inputlen>=5&&numberslen==3&&input[4]==")") newval+=")";
      else if(inputlen>=6&&numberslen==3&&input[5]==" ") newval+=" ";
      else if(inputlen>=10&&numberslen==6&&input[9]=="-") newval+="-";

      $(e.currentTarget).val(newval.substring(0,14));
    });
});
