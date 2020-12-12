using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Agenda.Models
{
    public class Task
    {
        public int TaskId { get; set; }
        public string  Sarcina{ get; set; }
        public string Prioritate { get; set; }
        public DateTime Deadline { get; set; }
        public DateTime TimeStamp { get; set; }
    }
}
