using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Laborator_3_1.Models
{
    public class ContactInfo
    {
        public int ContactInfoId { get; set; }
        public string PhoneNumber { get; set; }
        // one-to-one
        public virtual Publisher Publisher { get; set; }
    }
}