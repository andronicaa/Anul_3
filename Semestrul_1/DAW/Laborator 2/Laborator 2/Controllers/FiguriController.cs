using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using Laborator_2.Models;

namespace Laborator_2.Controllers
{
    public class FiguriController : Controller
    {
        // GET: Figuri
        public ActionResult Index()
        {
            return View();
        }
        public ActionResult Prima()
        {
            Figura f = new Figura();
            f.Nume = "Cerc";
            return View(f);
        }
    }
}