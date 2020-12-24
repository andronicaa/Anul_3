using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace Planner.Models.MyValidation
{
    public class AppointmentDateValidation : ValidationAttribute
    {
        protected override ValidationResult IsValid(object value, ValidationContext validationContext)
        {
            var apt = (Appointment)validationContext.ObjectInstance;
            

            DateTime dateApt = apt.Data;
            DateTime dateNow = DateTime.Now;
            bool cond = true;
            if (dateApt < dateNow)
            {
                cond = false;
            }

            return cond ? ValidationResult.Success : new ValidationResult("Data intalnirii trebuie sa fie mai mare decat data curenta!");
        }
    }
}