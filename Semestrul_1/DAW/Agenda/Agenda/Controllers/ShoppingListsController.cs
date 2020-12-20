using Agenda.DataAccessLayer;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Agenda.Controllers
{
    public class ShoppingListsController : Controller
    {
        private readonly IShoppingListRepo _repository;

        // dep injection
        public ShoppingListsController(IShoppingListRepo repository)
        {
            _repository = repository;
        }
        public IActionResult Index()
        {
            return View();
        }

        [Route("shoppinglists/getshoppinglistbyid/{id}")]
        public ActionResult GetShoppingListById(int? id)
        {
            var listItem = _repository.GetListById((int)id);
            return View("Detalii", listItem);
        }
    }
}
