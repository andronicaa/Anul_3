using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.ComponentModel.DataAnnotations;

namespace Laborator_3_1.Models.MyValidation
{
    public class PrimeNumberValidation : ValidationAttribute
    {
        protected override ValidationResult IsValid(object value, ValidationContext validationContext)
        {
            var book = (Book)validationContext.ObjectInstance;
            int pages = book.NoOfPages;
            bool cond = true;
            for (int i = 2; i <= Math.Sqrt(pages); i++)
            {
                if (pages % i == 0)
                {
                    cond = false;
                    break;
                }
            }
            return cond ? ValidationResult.Success : new ValidationResult("Acesta nu este un numar prim");
        }
    }
}