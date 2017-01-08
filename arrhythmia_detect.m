function [ RR_category, cat_tot ] = arrhythmia_detect( peak_diffs, RR_category, cat_tot )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here



      for i=2:(length(peak_diffs)-1)
          
          
          rr1 = peak_diffs(i-1);
          rr2 = peak_diffs(i);
          rr3 = peak_diffs(i+1);

          %Ventricular flutter/fibrillation
          if(rr2 < 0.6 && (1.8*rr2 < rr1));
             RR_category(i) = 3;
             
             for k = i+1:(size(peak_diffs)-1)
                 
                 rr1k = peak_diffs(k-1);
                 rr2k = peak_diffs(k);
                 rr3k = peak_diffs(k+1);
                 
                if((rr1k < 0.7 && rr2k < 0.7 && rr3k < 0.7) || (rr1k+rr2k+rr3k < 1.7))
                    RR_category(i) = 3;
                else %Less than 4 cycles = normal
                    if(RR_category(i-4)== 1 && RR_category(i-3)== 3 && RR_category(i-2)== 3 && RR_category(i-1)== 3)
                        RR_category(i-3) = 1;
                        RR_category(i-2) = 1;
                        RR_category(i-1) = 1;
                    end    
                end
             end
          end 
         
          %Premature ventricular contractions
          if(   ((1.15*rr2 < rr1)&&(1.15*rr2 < rr3))...
             ||((abs(rr1-rr2)< 0.3) && (rr1 < 0.8 && rr2 < 0.8)...
             && (rr3 > 1.2*((rr1+rr2)/2)))...
             ||(abs(rr2-rr3)< 0.3)&&(rr2 < 0.8 && rr3 < 0.8)...
             && (rr1 > 1.2 * ((rr2+rr3)/2))    )
                RR_category(i) = 2;
          end
          
         %2° heart block 
          if((2.2 < rr2 && rr2 < 3.0 )&&((abs(rr1-rr2) < 0.2) || (abs(rr2-rr3) < 0.2)))
              RR_category(i) = 4;
          end
      end

      
      
      
       %Sum of categories
      for i =1:length(peak_diffs)
         if (RR_category(i) == 1) 
            cat_tot(1) = cat_tot(1) + 1;
         end
         if (RR_category(i) == 2) 
            cat_tot(2) = cat_tot(2) + 1;
         end
         if (RR_category(i) == 3) 
            cat_tot(3) = cat_tot(3) + 1;
         end
         if (RR_category(i) == 4) 
            cat_tot(4) = cat_tot(4) + 1;          
         end
      end
      
      
      
end

