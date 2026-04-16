package complex.skip.app.ui.screens

import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp
import androidx.navigation.NavController
import complex.skip.app.RentalViewModel
import complex.skip.app.Theme.SurfacePrimary
import complex.skip.app.Theme.TextSecondary
import complex.skip.app.Theme.LuxuryGold
import androidx.compose.ui.graphics.Color
import complex.skip.app.DealerLocation
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.LocationOn
import androidx.compose.material.icons.filled.Map

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun MapScreen(viewModel: RentalViewModel, navController: NavController) {
    val dealers by remember { derivedStateOf { viewModel.allDealers } }
    val cars by remember { derivedStateOf { viewModel.nearbyCars } }

    Scaffold(
        topBar = { TopAppBar(title = { Text("Nearby Dealers & Cars") }) }
    ) { padding ->
        LazyColumn(
            modifier = Modifier.fillMaxSize().padding(padding),
            contentPadding = PaddingValues(16.dp),
            verticalArrangement = Arrangement.spacedBy(16.dp)
        ) {
            items(dealers.toList(), key = { it.name }) { dealer ->
                DealerCard(dealer = dealer) { /* nav to dealer detail */ }
            }
            items(cars.toList(), key = { it.id.toString() }) { car ->
                CarListItem(car = car, onClick = { navController.navigate("carDetail/${car.id}") })
            }
        }
    }
}

@Composable
fun DealerCard(dealer: DealerLocation, onClick: () -> Unit) {
    Card(
        modifier = Modifier.fillMaxWidth().clickable { onClick() },
        shape = RoundedCornerShape(16.dp),
        colors = CardDefaults.cardColors(containerColor = SurfacePrimary)
    ) {
        Column(modifier = Modifier.padding(16.dp)) {
            Row(verticalAlignment = Alignment.CenterVertically) {
                Icon(imageVector = Icons.Default.LocationOn, contentDescription = null, tint = LuxuryGold)
                Text(dealer.name, style = MaterialTheme.typography.titleMedium, modifier = Modifier.weight(1f))
                RatingBar(rating = dealer.rating, size = 14)
            }
            Text(dealer.fullAddress, style = MaterialTheme.typography.bodyMedium, color = TextSecondary)
            Row(horizontalArrangement = Arrangement.SpaceBetween) {
                Text(dealer.phone, style = MaterialTheme.typography.labelSmall)
                Text("Open until 8 PM", style = MaterialTheme.typography.labelSmall)
            }
            Button(
                onClick = {},
                modifier = Modifier.fillMaxWidth(),
                colors = ButtonDefaults.buttonColors(containerColor = LuxuryGold, contentColor = Color.Black),
                shape = CircleShape
            ) {
                Icon(imageVector = Icons.Default.Map, contentDescription = null)
                Text("Get Directions")
            }
        }
    }
}