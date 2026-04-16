package complex.skip.app.Theme

import androidx.compose.foundation.isSystemInDarkTheme
import androidx.compose.material3.*
import androidx.compose.runtime.Composable
import androidx.compose.ui.graphics.Color

@Composable
fun LuxuryWheelsTheme(
    darkTheme: Boolean = isSystemInDarkTheme(),
    content: @Composable () -> Unit
) {
    val colorScheme = darkColorScheme(
        primary = LuxuryGold,
        onPrimary = Color.Black,
        background = BackgroundPrimary,
        surface = SurfacePrimary,
        onBackground = TextPrimary,
        onSurface = TextPrimary,
        secondary = SurfaceSecondary,
        onSecondary = TextSecondary
    )

    MaterialTheme(
        colorScheme = colorScheme,
        typography = Typography(),
        content = content
    )
}