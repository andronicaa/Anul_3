using Agenda.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Agenda.ViewModels
{
    public class PersonContactViewModel
    {
        public Person Person { get; set; }
        public ContactInfo ContactInfo { get; set; }
    }
}
