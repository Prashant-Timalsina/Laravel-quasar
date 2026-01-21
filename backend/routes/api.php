<?php

use App\Http\Controllers\NoteController;
use App\Http\Controllers\UserController;
use \Illuminate\Support\Facades\Route;
use Illuminate\Http\Request;


Route::post('/register',[UserController::class,'register'])->name('register');
Route::get('/users',[UserController::class,'index'])->name('users.index');
Route::post('/login',[UserController::class,'login'])->name('login');

Route::middleware('auth:sanctum')->group(function () {
    Route::post('/logout',[UserController::class,'logout'])->name('logout');
    Route::post('logout-all',[UserController::class,'logoutAll'])->name('logoutAll');

    Route::get('/me', function(Request $request){
        return $request->user();
    });

    Route::apiResource('notes',NoteController::class);
});


// backend/routes/api.php
Route::get('/test', function () {
    return response()->json([
        'status' => 'ok',
        'message' => 'CORS working'
    ]);
});

