using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Planner.Models.ViewModels
{
    public class PersonContactInfoViewModel
    {
        public Person Person { get; set; }
        public ContactInfo ContactInfo { get; set; }
    }
}