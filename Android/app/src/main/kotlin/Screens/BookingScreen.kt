package complex.skip.app.ui.screens

import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.navigation.NavController
import coil.compose.AsyncImage
import complex.skip.app.Car
import complex.skip.app.CarColor
import complex.skip.app.InsuranceOption
import complex.skip.app.PaymentMethod
import complex.skip.app.RentalViewModel
import complex.skip.app.Theme.BackgroundPrimary
import complex.skip.app.Theme.LuxuryGold
import complex.skip.app.Theme.SurfacePrimary
import complex.skip.app.Theme.TextSecondary
import complex.skip.app.Theme.TextPrimary
import java.text.SimpleDateFormat
import skip.foundation.Date
import java.util.Locale
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.CheckCircle
import androidx.compose.material.icons.filled.Close
import androidx.compose.material.icons.filled.Lock
import androidx.compose.material.icons.filled.Settings

data class PromoCode(
    val code: String,
    val discountPercentage: Double,
    val description: String
)

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun BookingScreen(
    viewModel: RentalViewModel,
    navController: NavController,
    carId: String?
) {
    val car = remember(carId) { viewModel.allCars.find { it.id.toString() == carId } }
    if (car == null) {
        Box(modifier = Modifier.fillMaxSize(), contentAlignment = Alignment.Center) {
            CircularProgressIndicator(color = LuxuryGold)
        }
        return
    }

    val now = Date()
    var startDate by remember { mutableStateOf(now) }
    var endDate by remember { mutableStateOf(now.addingTimeInterval(3 * 24 * 60 * 60.0)) }
    var pickupTime by remember { mutableStateOf("10:00 AM") }
    var returnTime by remember { mutableStateOf("10:00 AM") }
    var selectedColor by remember { mutableStateOf(car.colorOptions.firstOrNull() ?: CarColor("", "", 0.0)) }
    var selectedInsurance by remember { mutableStateOf<InsuranceOption?>(null) }
    var selectedPaymentMethod by remember { mutableStateOf(viewModel.currentUser?.paymentMethods?.firstOrNull { it.isDefault }) }
    var agreeToTerms by remember { mutableStateOf(false) }
    var promoCode by remember { mutableStateOf("") }
    var appliedPromo by remember { mutableStateOf<PromoCode?>(null) }
    var showPaymentSheet by remember { mutableStateOf(false) }
    var showConfirmation by remember { mutableStateOf(false) }

    val rentalDays = remember(startDate, endDate) {
        val diffSeconds = endDate.timeIntervalSince1970 - startDate.timeIntervalSince1970
        (diffSeconds / (60 * 60 * 24)).toInt().coerceAtLeast(1)
    }

    val subtotal = car.pricePerDay * rentalDays
    val insuranceCost = (selectedInsurance?.pricePerDay ?: 0.0) * rentalDays
    val colorPremium = selectedColor.pricePremium
    val promoDiscount = appliedPromo?.let { subtotal * (it.discountPercentage / 100) } ?: 0.0
    val taxes = subtotal * 0.0825
    val total = subtotal + insuranceCost + colorPremium + taxes - promoDiscount

    val timeSlots = listOf(
        "8:00 AM", "9:00 AM", "10:00 AM", "11:00 AM", "12:00 PM",
        "1:00 PM", "2:00 PM", "3:00 PM", "4:00 PM", "5:00 PM",
        "6:00 PM", "7:00 PM", "8:00 PM"
    )

    val canBook = selectedPaymentMethod != null && agreeToTerms && rentalDays > 0

    val scope = rememberCoroutineScope()

    Scaffold(
        topBar = {
            TopAppBar(
                title = { Text("Book Your Rental") },
                navigationIcon = {
                    IconButton(onClick = { navController.popBackStack() }) {
                        Icon(imageVector = Icons.Default.Close, contentDescription = "Cancel")                    }
                }
            )
        }
    ) { padding ->
        LazyColumn(
            modifier = Modifier
                .fillMaxSize()
                .padding(padding)
                .background(BackgroundPrimary),
            contentPadding = PaddingValues(16.dp),
            verticalArrangement = Arrangement.spacedBy(24.dp)
        ) {
            item {
                CarSummaryCard(car = car, selectedColor = selectedColor)
            }

            item {
                Column(verticalArrangement = Arrangement.spacedBy(12.dp)) {
                    Text("Rental Period", style = MaterialTheme.typography.titleMedium)
                    Card(
                        shape = RoundedCornerShape(12.dp),
                        colors = CardDefaults.cardColors(containerColor = SurfacePrimary)
                    ) {
                        Column(modifier = Modifier.padding(16.dp)) {
                            DatePickerRow(label = "Pickup Date", date = startDate, onDateChange = { startDate = it })
                            TimePickerRow(label = "Pickup Time", time = pickupTime, options = timeSlots, onTimeChange = { pickupTime = it })
                            Divider(modifier = Modifier.padding(vertical = 8.dp))
                            DatePickerRow(label = "Return Date", date = endDate, onDateChange = { endDate = it })
                            TimePickerRow(label = "Return Time", time = returnTime, options = timeSlots, onTimeChange = { returnTime = it })
                        }
                    }
                }
            }

            item {
                Column(verticalArrangement = Arrangement.spacedBy(12.dp)) {
                    Text("Price Details", style = MaterialTheme.typography.titleMedium)
                    Card(
                        shape = RoundedCornerShape(12.dp),
                        colors = CardDefaults.cardColors(containerColor = SurfacePrimary)
                    ) {
                        Column(modifier = Modifier.padding(16.dp), verticalArrangement = Arrangement.spacedBy(8.dp)) {
                            PriceRow(label = "${car.make} ${car.model} × $rentalDays days", amount = subtotal)
                            if (colorPremium > 0) {
                                PriceRow(label = "Color: ${selectedColor.name}", amount = colorPremium)
                            }
                            selectedInsurance?.let {
                                PriceRow(label = "Insurance: ${it.name}", amount = insuranceCost)
                            }
                            appliedPromo?.let {
                                PriceRow(label = "Promo: ${it.code}", amount = -promoDiscount, amountColor = Color.Green)
                            }
                            PriceRow(label = "Taxes & Fees", amount = taxes)
                            Divider()
                            Row(
                                modifier = Modifier.fillMaxWidth(),
                                horizontalArrangement = Arrangement.SpaceBetween
                            ) {
                                Text("Total", style = MaterialTheme.typography.titleMedium, fontWeight = FontWeight.Bold)
                                Text(
                                    "$%.2f".format(total),
                                    style = MaterialTheme.typography.titleLarge,
                                    color = LuxuryGold,
                                    fontWeight = FontWeight.Bold
                                )
                            }
                        }
                    }
                }
            }

            item {
                Column(verticalArrangement = Arrangement.spacedBy(8.dp)) {
                    Text("Promo Code", style = MaterialTheme.typography.titleMedium)
                    Row(horizontalArrangement = Arrangement.spacedBy(8.dp)) {
                        OutlinedTextField(
                            value = promoCode,
                            onValueChange = { promoCode = it },
                            placeholder = { Text("Enter promo code") },
                            modifier = Modifier.weight(1f),
                            shape = RoundedCornerShape(8.dp)
                        )
                        Button(
                            onClick = {
                                when (promoCode.uppercase()) {
                                    "LUXURY20" -> appliedPromo = PromoCode("LUXURY20", 20.0, "20% off")
                                    "FIRST10" -> appliedPromo = PromoCode("FIRST10", 10.0, "10% off")
                                }
                            },
                            enabled = promoCode.isNotBlank(),
                            colors = ButtonDefaults.buttonColors(containerColor = LuxuryGold, contentColor = Color.Black)
                        ) {
                            Text("Apply")
                        }
                    }
                }
            }

            item {
                Column(verticalArrangement = Arrangement.spacedBy(8.dp)) {
                    Row(
                        modifier = Modifier.fillMaxWidth(),
                        horizontalArrangement = Arrangement.SpaceBetween,
                        verticalAlignment = Alignment.CenterVertically
                    ) {
                        Text("Payment Method", style = MaterialTheme.typography.titleMedium)
                        TextButton(onClick = { showPaymentSheet = true }) {
                            Text("Change", color = LuxuryGold)
                        }
                    }
                    selectedPaymentMethod?.let {
                        PaymentMethodCard(method = it)
                    } ?: run {
                        Button(
                            onClick = { showPaymentSheet = true },
                            modifier = Modifier.fillMaxWidth(),
                            colors = ButtonDefaults.buttonColors(containerColor = SurfacePrimary, contentColor = TextPrimary),
                            shape = RoundedCornerShape(12.dp)
                        ) {
                            Icon(imageVector = Icons.Default.CheckCircle, contentDescription = null, tint = LuxuryGold)
                            Text("Add Payment Method")
                        }
                    }
                }
            }

            item {
                Row(verticalAlignment = Alignment.CenterVertically) {
                    Checkbox(
                        checked = agreeToTerms,
                        onCheckedChange = { agreeToTerms = it },
                        colors = CheckboxDefaults.colors(checkedColor = LuxuryGold)
                    )
                    Text("I agree to the ", style = MaterialTheme.typography.labelSmall)
                    TextButton(onClick = {}) { Text("Terms & Conditions", color = LuxuryGold) }
                    Text(" and ", style = MaterialTheme.typography.labelSmall)
                    TextButton(onClick = {}) { Text("Rental Agreement", color = LuxuryGold) }
                }
            }

            item {
                Button(
                    onClick = {
                        selectedPaymentMethod?.let { pm ->
                            viewModel.createRental(
                                car = car,
                                startDate = startDate,
                                endDate = endDate,
                                totalPrice = total,
                                insurance = selectedInsurance,
                                color = selectedColor,
                                paymentMethod = pm
                            )
                            viewModel.addBonusCredits(500.0)
                            showConfirmation = true
                        }
                    },
                    modifier = Modifier.fillMaxWidth().padding(vertical = 16.dp),
                    enabled = canBook,
                    colors = ButtonDefaults.buttonColors(containerColor = if (canBook) LuxuryGold else Color.Gray),
                    shape = CircleShape
                ) {
                    Row(verticalAlignment = Alignment.CenterVertically) {
                        Text("Confirm & Pay")
                        Icon(imageVector = Icons.Default.Lock, contentDescription = null)
                    }
                }
            }
        }
    }

    if (showPaymentSheet) {
        PaymentMethodsBottomSheet(
            paymentMethods = viewModel.currentUser?.paymentMethods ?: emptyList(),
            selected = selectedPaymentMethod,
            onSelect = { method ->
                selectedPaymentMethod = method
                showPaymentSheet = false
            },
            onDismiss = { showPaymentSheet = false }
        )
    }

    if (showConfirmation) {
        AlertDialog(
            onDismissRequest = { showConfirmation = false },
            title = { Text("Booking Confirmed") },
            text = { Text("Your ${car.make} ${car.model} is ready! Check-in details have been sent to your email.") },
            confirmButton = {
                TextButton(onClick = {
                    showConfirmation = false
                    navController.navigate("rentals") { popUpTo("explore") }
                }) {
                    Text("View My Rentals")
                }
            },
            dismissButton = {
                TextButton(onClick = {
                    showConfirmation = false
                    navController.popBackStack()
                }) {
                    Text("Done")
                }
            }
        )
    }
}

// ---------- Components ----------

@Composable
fun CarSummaryCard(car: Car, selectedColor: CarColor) {
    Card(
        shape = RoundedCornerShape(12.dp),
        colors = CardDefaults.cardColors(containerColor = SurfacePrimary)
    ) {
        Row(
            modifier = Modifier.padding(16.dp),
            verticalAlignment = Alignment.CenterVertically
        ) {
//            AsyncImage(
//                model = getLocalImageId(car.images.firstOrNull()),
//                contentDescription = null,
//                modifier = Modifier.size(80.dp, 60.dp).clip(RoundedCornerShape(8.dp))
//            )
            AppImage(
                source = car.images.firstOrNull(),
                modifier = Modifier.size(80.dp, 60.dp).clip(RoundedCornerShape(8.dp))
            )
            Spacer(modifier = Modifier.width(16.dp))
            Column(modifier = Modifier.weight(1f)) {
                Text("${car.year} ${car.make} ${car.model}", style = MaterialTheme.typography.titleSmall)
                Row(verticalAlignment = Alignment.CenterVertically) {
                    Box(modifier = Modifier.size(12.dp).clip(CircleShape).background(Color(android.graphics.Color.parseColor(selectedColor.hexCode))))
                    Spacer(modifier = Modifier.width(4.dp))
                    Text(selectedColor.name, style = MaterialTheme.typography.labelSmall, color = TextSecondary)
                }
                RatingBar(rating = car.rating, size = 12)
            }
        }
    }
}


@Composable
fun DatePickerRow(label: String, date: Date, onDateChange: (Date) -> Unit) {
    Row(
        modifier = Modifier.fillMaxWidth(),
        horizontalArrangement = Arrangement.SpaceBetween,
        verticalAlignment = Alignment.CenterVertically
    ) {
        Text(label, style = MaterialTheme.typography.bodyMedium)
        TextButton(onClick = { /* show date picker */ }) {
            val javaDate = java.util.Date(date.timeIntervalSince1970.toLong() * 1000)
            Text(SimpleDateFormat("MMM dd, yyyy", Locale.getDefault()).format(javaDate))
        }
    }
}

@Composable
fun TimePickerRow(label: String, time: String, options: List<String>, onTimeChange: (String) -> Unit) {
    var expanded by remember { mutableStateOf(false) }
    Row(
        modifier = Modifier.fillMaxWidth(),
        horizontalArrangement = Arrangement.SpaceBetween,
        verticalAlignment = Alignment.CenterVertically
    ) {
        Text(label, style = MaterialTheme.typography.bodyMedium)
        Box {
            TextButton(onClick = { expanded = true }) { Text(time) }
            DropdownMenu(
                expanded = expanded,
                onDismissRequest = { expanded = false }
            ) {
                options.forEach { option ->
                    DropdownMenuItem(
                        text = { Text(option) },
                        onClick = {
                            onTimeChange(option)
                            expanded = false
                        }
                    )
                }
            }
        }
    }
}

@Composable
fun PriceRow(label: String, amount: Double, amountColor: Color = TextPrimary) {
    Row(
        modifier = Modifier.fillMaxWidth(),
        horizontalArrangement = Arrangement.SpaceBetween
    ) {
        Text(label, style = MaterialTheme.typography.bodyMedium, color = TextSecondary)
        Text(
            if (amount < 0) "-$${"%.2f".format(-amount)}" else "$${"%.2f".format(amount)}",
            style = MaterialTheme.typography.bodyMedium,
            color = amountColor
        )
    }
}

/**
 * Displays a single payment method.
 *
 * @param method The payment method to display.
 */
@Composable
fun PaymentMethodCard(method: PaymentMethod) {
    Card(
        shape = RoundedCornerShape(12.dp),
        colors = CardDefaults.cardColors(containerColor = SurfacePrimary)
    ) {
        Row(
            modifier = Modifier.padding(16.dp),
            verticalAlignment = Alignment.CenterVertically
        ) {
            Icon(imageVector = Icons.Default.Settings, contentDescription = null, tint = LuxuryGold)
            Spacer(modifier = Modifier.width(12.dp))
            Column(modifier = Modifier.weight(1f)) {
                Text("${method.type.name} •••• ${method.lastFour}", style = MaterialTheme.typography.bodyMedium)
                Text("Expires ${method.expiryDate}", style = MaterialTheme.typography.labelSmall, color = TextSecondary)
            }
            if (method.isDefault) {
                Badge(text = "Default", color = LuxuryGold)
            }
            Icon(imageVector = Icons.Default.CheckCircle, contentDescription = null, tint = LuxuryGold)
        }
    }
}

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun PaymentMethodsBottomSheet(
    paymentMethods: Iterable<PaymentMethod>,
    selected: PaymentMethod?,
    onSelect: (PaymentMethod) -> Unit,
    onDismiss: () -> Unit
) {
    ModalBottomSheet(
        onDismissRequest = onDismiss,
        containerColor = SurfacePrimary
    ) {
        Column(
            modifier = Modifier
                .fillMaxWidth()
                .padding(16.dp),
            verticalArrangement = Arrangement.spacedBy(8.dp)
        ) {
            Text("Payment Methods", style = MaterialTheme.typography.titleLarge)
            paymentMethods.forEach { method ->
                Box(
                    modifier = Modifier
                        .fillMaxWidth()
                        .clickable { onSelect(method) }
                ) {
                    PaymentMethodCard(method = method)
                }
                if (method == selected) {
                    Icon(imageVector = Icons.Default.CheckCircle, contentDescription = null, tint = LuxuryGold)
                }
            }
            Button(
                onClick = { },
                modifier = Modifier.fillMaxWidth(),
                colors = ButtonDefaults.buttonColors(containerColor = LuxuryGold, contentColor = Color.Black)
            ) {
                Text("Add New Payment Method")
            }
        }
    }
}