using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace Planner.Models.MyValidation
{
    public class DateValidation : ValidationAttribute
    {
        protected override ValidationResult IsValid(object value, ValidationContext validationContext)
        {
            var invoice = (Invoice)validationContext.ObjectInstance;
            DateTime dataEmit = invoice.DataEmitere;
            DateTime dataScad = invoice.DataScadenta;
            bool cond = true;
            if (dataScad < dataEmit)
            {
                cond = false;
            }

            return cond ? ValidationResult.Success : new ValidationResult("Data scadenta trebuie sa fie mai mare decat data de emitere!");
        }
    }
}