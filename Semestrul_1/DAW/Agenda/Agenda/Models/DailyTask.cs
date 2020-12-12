using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Agenda.Models
{
    public class DailyTask
    {
        public int TaskId { get; set; }
        public string  Sarcina{ get; set; }
        public string Prioritate { get; set; }
        public string Deadline { get; set; }
    }
}
