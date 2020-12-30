﻿using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace Planner.Models.MyValidation
{
    public class DailyTaskValidation : ValidationAttribute
    {
        protected override ValidationResult IsValid(object value, ValidationContext validationContext)
        {
            var apt = (DailyTask)validationContext.ObjectInstance;


            DateTime dateApt = apt.Deadline;
            DateTime dateNow = DateTime.Now;
            bool cond = true;
            if (dateApt < dateNow)
            {
                cond = false;
            }

            return cond ? ValidationResult.Success : new ValidationResult("Deadline-ul trebuie sa fie in aceeasi zi intr-o zi urmatoare");
        }
    }
}