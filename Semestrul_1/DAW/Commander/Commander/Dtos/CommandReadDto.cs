using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Commander.Dtos
{
    public class CommandReadDto
    {
        public string HowTo { get; set; }
        public string Line { get; set; }
        public object Id { get; internal set; }
    }
}
