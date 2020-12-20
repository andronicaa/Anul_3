using Proiect.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace Proiect.Controllers
{
    [Authorize(Roles = "Admin")]
    public class UsersController : Controller
    {
        // GET: Users
        private ApplicationDbContext ctx = new ApplicationDbContext();
        public ActionResult Index()
        {
            var users = ctx.Users.OrderBy(x => x.Email).ToList();

            ViewBag.Users = users;
            return View();
        }
    }
}